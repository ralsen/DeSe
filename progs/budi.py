import logging
import os
import requests
import time
import json
import yaml
import subprocess
from copy import deepcopy

import config

logger = logging.getLogger(__name__)
logging.getLogger('urllib3').setLevel(logging.WARNING)

# ============================================================================== 
#  Hilfsfunktionen und Validierung
# ============================================================================== 

REQUIRED_LISTS = {
    "base_cmd",
    "base_def",
    "base_vdef",
    "base_line",
    "base_gprint",
}


def validate_rrd_schema(cfg: dict, logger) -> None:
    """Frühe Validierung der diagrams.yml-Struktur."""
    for key in REQUIRED_LISTS:
        if key not in cfg:
            raise ValueError(f"Missing required diagrams.yml section: {key}")
        if not isinstance(cfg[key], list):
            raise TypeError(f"{key} must be a list")


def safe_format(s: str, logger, **kwargs):
    """Format mit Fehlertoleranz für kaputte YAML-Einträge."""
    try:
        return s.format(**kwargs)
    except KeyError as e:
        logger.warning(f"Missing placeholder {e} in '{s}'")
    except Exception as e:
        logger.warning(f"Format error in '{s}': {e}")
    return None


# ============================================================================== 
#  RRDTool Command Builder
# ============================================================================== 

class RrdCommandBuilder:
    """Kapselt den vollständigen Aufbau und Aufruf von rrdtool graph."""

    def __init__(self, dias: dict, logger, dry_run: bool = False):
        self.dias = dias
        self.logger = logger
        self.dry_run = dry_run

    def build_base(self, **kwargs) -> list[str]:
        cmd = []
        for arg in self.dias["base_cmd"]:
            f = safe_format(arg, self.logger, **kwargs)
            if f:
                cmd.append(f)
        return cmd

    def build_channel(self, ch: dict, rrd_path: str, orgnode: str) -> list[str]:
        cmd = []

        # DEF
        for arg in self.dias["base_def"]:
            f = safe_format(
                arg,
                self.logger,
                rrd_DS=ch["rrd_DS"],
                rrd_path=rrd_path,
                orgnode=orgnode,
            )
            if f:
                cmd.append(f)

        # optional CDEF
        if ch.get("CDEF"):
            cdef_expr = ch["CDEF"]
            cmd.append(f"CDEF:{cdef_expr}")
            effective_ds = cdef_expr.split("=")[0]
        else:
            effective_ds = ch["rrd_DS"]

        # VDEF
        for arg in self.dias["base_vdef"]:
            f = safe_format(arg, self.logger, rrd_DS=effective_ds)
            if f:
                cmd.append(f)

        # STYLE
        style = (
            self.dias["base_area"]
            if ch.get("style") == "AREA"
            else self.dias["base_line"]
        )

        name = ch["Name"]
        # feste Spaltenbreite für saubere Legenden-Ausrichtung
        legend_width = 22
        spaces = " " * max(1, legend_width - len(name))

        for arg in style:
            f = safe_format(
                arg,
                self.logger,
                rrd_DS=effective_ds,
                color=ch["color"],
                name=name,
                spaces=spaces,
            )
            if f:
                cmd.append(f)

        # GPRINT
        for arg in self.dias["base_gprint"]:
            f = safe_format(arg, self.logger, rrd_DS=effective_ds)
            if f:
                cmd.append(f)

        return cmd

    def run(self, cmd: list[str]) -> None:
        if self.dry_run:
            self.logger.info("DRY-RUN rrdtool: %s", cmd)
            return

        self.logger.debug("RRD CMD: %s", cmd)
        res = subprocess.run(cmd, capture_output=True, text=True)
        if res.returncode != 0:
            self.logger.error(res.stderr)


# ============================================================================== 
#  BuildGraphics
# ============================================================================== 

class BuildGraphics:
    """
    Erstellt RRD-Grafiken auf Basis der diagrams.yml-Konfiguration.
    """

    def __init__(self, cfg: dict):
        self.cfg = cfg

        validate_rrd_schema(self.cfg['dias'], logger)
        self.rrd = RrdCommandBuilder(self.cfg['dias'], logger, dry_run=self.cfg.get("DryRun", False))

        logger.info("BuildGraphics initialized.")

    # --------------------------------------------------------------------------

    def safe_req(self, url, retries=5, delay=2, timeout=10):
        for attempt in range(1, retries + 1):
            try:
                response = requests.get(url, timeout=timeout)
                response.raise_for_status()
                return response
            except requests.RequestException as e:
                logger.warning(f"Attempt {attempt}/{retries} failed: {e}")
                if attempt < retries:
                    time.sleep(delay)
                else:
                    logger.error(f"All {retries} attempts for {url} have failed.")
                    return None

    # --------------------------------------------------------------------------

    def MakeAllGraphs(self) -> None:
        logger.debug("Starting MakeAllGraphs")
        ServerName = self.cfg['DeSeName']
        ServerPort = self.cfg['DeSePort']
        res = self.safe_req(f'http://{ServerName}:{ServerPort}/sendDevList')
        if not res or res.status_code != 200:
            logger.error("Failed to get device list")
            return

        data = json.loads(res.text)
        for name in data:
            if name in self.cfg['dias']:
                self.MakeSplitGraph(name)
        logger.debug("All Graphics updated.")                

    # --------------------------------------------------------------------------

    def count_keys(self, d: dict, prefix: str = "channel") -> int:
        count = 0
        if isinstance(d, dict):
            for key, value in d.items():
                if key.startswith(prefix):
                    count += 1
                count += self.count_keys(value, prefix)
        elif isinstance(d, list):
            for item in d:
                count += self.count_keys(item, prefix)
        return count

    # --------------------------------------------------------------------------

    def MakeSplitGraph(self, node: str) -> None:
        if "split" not in self.cfg['dias'][node]:
            self.MakeGraph(node)
            return

        split_groups = self.cfg['dias'][node]["split"]
        time_text = deepcopy(self.cfg['dias'][node].get("TimeText", []))

        for group in split_groups:
            if not group:
                continue
            group_name = group[0]
            channel_keys = group[1:]

            new_dict = {"TimeText": deepcopy(time_text)}
            for key in channel_keys:
                if key in self.cfg['dias'][node]:
                    new_dict[key] = deepcopy(self.cfg['dias'][node][key])

            self.cfg['dias'][group_name] = new_dict
            self.MakeGraph(group_name, node)

    # --------------------------------------------------------------------------

    def MakeGraph(self, node: str, orgnode: str = None):
        if node not in self.cfg['dias']:
            logger.warning(f"Node {node} not found in diagrams configuration.")
            return

        if orgnode is None:
            orgnode = node

        node_data = self.cfg['dias'][node]
        channels = self.count_keys(self.cfg['dias'][orgnode])
        if channels == 0:
            logger.warning(f"No channels found for Node: {node}")
            return

        pic_path = self.cfg['PNGPath']
        rrd_path = self.cfg['RRDPath']

        units = []
        for i in range(channels):
            ch_key = f"channel_{i}"
            if ch_key in node_data:
                units.append(node_data[ch_key].get('Unit', ''))
        unit_str = "[" + ", ".join(units) + "]"

        for time_count, time_unit in node_data.get("TimeText", []):
            time_text = f"{time_count}_{time_unit}"

            cmd = self.rrd.build_base(
                pic_path=pic_path,
                node=node,
                time_text=time_text,
                unit=unit_str,
                time_count=time_count,
                time_unit=time_unit,
            )

            # Kommentar + Leerzeile für saubere Trennung zur Legende
            for c in self.cfg['dias'].get("base_comment", []):
                cmd.append(c+"\\n")
            cmd.append("COMMENT:\n")

            for i in range(channels):
                ch_key = f"channel_{i}"
                if ch_key in node_data:
                    ch = node_data[ch_key]
                    if ch.get("ID") is False:
                        continue
                    cmd.extend(self.rrd.build_channel(ch, rrd_path, orgnode))
                    # jede Legendenzeile explizit umbrechen
                    cmd.append("COMMENT:\\n")

            self.rrd.run(cmd)
            logger.debug(f"Graph created for {node} - {time_text}")


# ============================================================================== 
#  Main
# ============================================================================== 

if __name__ == '__main__':
    current_file_path = os.path.realpath(__file__)
    current_file_name = os.path.basename(current_file_path)

    cfg = config.InitManager(current_file_name)
    logger.info(f'---------- starting {current_file_name} ----------')

    bg = BuildGraphics(cfg)
    bg.MakeAllGraphs()

    while True:
        time.sleep(10)

