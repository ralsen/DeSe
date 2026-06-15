import logging
import os
import requests
import time
import json
import yaml
from copy import deepcopy

import config

logger = logging.getLogger(__name__)
logging.getLogger('urllib3').setLevel(logging.WARNING)

class BuildGraphics:
    """
    The BuildGraph class is used to create and manage graphs for monitoring data.
    It initializes the graph with a given node and provides methods to build the graph.
    """
    def __init__(self, cfg: dict):
        """
        The function initializes a BuildGraph object with a given Node.
        """
        self.cfg = cfg
        current_dir = os.getcwd()
        current_dir += '/..'
        with open(f'{current_dir}/yml/diagrams.yml', 'r') as ymlfile:
            self.dias = yaml.safe_load(ymlfile)
        logger.info(f"BuildGraphics initialized.")
        logger.debug(f"using diagrams: {self.dias}")

# --------------------------------------------------------------------------------------------------

    def safe_req(self, url, retries=5, delay=2, timeout=10):
        for attempt in range(1, retries + 1):
            try:
                response = requests.get(url, timeout=timeout)
                response.raise_for_status()
                return response
            except requests.RequestException as e:
                logging.warning(f"Attempt {attempt}/{retries} failed: {e}")
                if attempt < retries:
                    time.sleep(delay)
                else:
                    logging.error(f"All {retries} attempts for {url} have failed.")
                    return None

# --------------------------------------------------------------------------------------------------

    def MakeAllGraphs(self) -> None:
        logger.info("Starting MakeAllGraphs")
        ServerName = self.cfg['DeSeName']
        ServerPort = self.cfg['DeSePort']
        res = self.safe_req(f'http://{ServerName}:{ServerPort}/sendDevList')  
        if res.status_code != 200:
            logger.error(f"Failed to get device list from {ServerName}:{ServerPort}. Status code: {res.status_code}")
            return
        data = json.loads(res.text) 
        #test_devices = '[ "cpustats", "weather", "sda", "~sdb", "eth0", "Jan-CC50E35DA7A5", "shellyplug-083A8DF437C7", "~DaBo", "System"]'
        #data = json.loads(test_devices) 
        logger.debug(f"Received device list: {data}")
        for Name in data:
            if Name in self.dias:
                self.MakeSplitGraph(Name)
        logger.info("All Graphics updated.")


# --------------------------------------------------------------------------------------------------

    def count_keys(self, d: str, prefix: str = "channel") -> int:
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
    
# --------------------------------------------------------------------------------------------------

    def MakeSplitGraph(self, node: str) -> dict:
        # Prüfung: Existiert "split" überhaupt?
        if "split" not in self.dias[node]:
            self.MakeGraph(node)
            return

        result = {}
        split_groups = self.dias[node]["split"]
        time_text = deepcopy(self.dias[node].get("TimeText", []))

        for group in split_groups:
            if not group:
                continue  # Leere Gruppen überspringen

            group_name = group[0]
            channel_keys = group[1:]

            new_dict = {"TimeText": deepcopy(time_text)}

            for key in channel_keys:
                if key in self.dias[node]:
                    new_dict[key] = deepcopy(self.dias[node][key])

            result[group_name] = new_dict
            self.dias |= result
            self.MakeGraph(group_name, node)
        return result
# --------------------------------------------------------------------------------------------------

    def MakeGraph(self, node: str, orgnode: str = None):
        if node not in self.dias:
            logger.warning(f"Node {node} not found in diagrams configuration.")
            return
        logger.info(f"MakeGraph called for Node: {node}")
        if orgnode is None:
            orgnode = node
            logger.debug(f"node is: {node} - Original Node: {orgnode}")
        
        channels = self.count_keys(self.dias[orgnode])
        if channels == 0:
            logger.warning(f"No channels found for Node: {node}. Skipping graph creation.")
            return
        logger.debug(f"Found {channels} channels")

        pic_path = self.cfg['PNGPath']
        rrd_path = self.cfg['RRDPath']
        node_data = self.dias[node]

        # Basis-Befehl
        base_cmd = (
            "rrdtool graph \"{pic_path}/{node}_{time_text}.png\" "
            "-t \"{node} ({time_text})\" --vertical-label \"{unit}\" "
            "-s \"now - {time_count} {time_unit}\" -e \"now\" -w 700 -h 200 "
        )

        comment_line = (
            "COMMENT:\"                         Durchschnitt   Maximum   Minimum    aktuell\\n\""
        )

        # Kanalbefehle vorbereiten
        def channel_cmd(channel):
            ch = node_data[channel]
            if ch.get("ID") is False:
                return "", ""

            name = ch["Name"]
            spaces = " " * max(1, 20 - len(name))
            vdef_str = (
                f"VDEF:{ch['rrd_DS']}_av={ch['rrd_DS']},AVERAGE "
                f"VDEF:{ch['rrd_DS']}_ma={ch['rrd_DS']},MAXIMUM "
                f"VDEF:{ch['rrd_DS']}_mi={ch['rrd_DS']},MINIMUM "
                f"VDEF:{ch['rrd_DS']}_ak={ch['rrd_DS']},LAST "
            )
            line_str = (
                f"LINE1:{ch['rrd_DS']}{ch['color']}:\"{name}{spaces}\" "
            )
            area_str = (
                f"AREA:{ch['rrd_DS']}{ch['color']}:\"{name}{spaces}\" "
            )
            gprint_str = (
                f"GPRINT:{ch['rrd_DS']}_av:\" %8.2lf\" "
                f"GPRINT:{ch['rrd_DS']}_ma:\" %8.2lf\" "
                f"GPRINT:{ch['rrd_DS']}_mi:\" %8.2lf\" "
                f"GPRINT:{ch['rrd_DS']}_ak:\" %8.2lf\" "
                f"COMMENT:\"                    {ch['ID']}\\n\" "
            )

            def_str = f"DEF:{ch['rrd_DS']}={rrd_path}/{orgnode}.rrd:{ch['rrd_DS']}:AVERAGE"
            if ch.get("CDEF"):
                def_str += f" CDEF:{ch['CDEF']}"
                cdef_str = ch['CDEF'].split('=')[0]
                area_str = area_str.replace(f"{ch['rrd_DS']}", cdef_str)
                line_str = line_str.replace(f"{ch['rrd_DS']}", cdef_str)
                vdef_str = vdef_str.replace(f"{ch['rrd_DS']}", cdef_str)
                gprint_str = gprint_str.replace(f"{ch['rrd_DS']}", cdef_str)
                
            if ch.get("style") == "AREA":
                style_str = area_str
            else:
                style_str = line_str
            return def_str + " " + vdef_str, style_str + gprint_str

        # Einmal alle Kanal-Strings bauen
        def_parts, gprint_parts, units = [], [], []
        for i in range(channels):
            ch_key = f'channel_{i}'
            if ch_key in node_data:
                def_vdef, gprint = channel_cmd(ch_key)
                if def_vdef:
                    def_parts.append(def_vdef)
                    gprint_parts.append(gprint)
                    units.append(node_data[ch_key]['Unit'])

        unit_str = "[" + ", ".join(units) + "]"

        for time_count, time_unit in node_data.get("TimeText", []):
            time_text = f"{time_count}_{time_unit}"
            cmd = base_cmd.format(
                pic_path=pic_path,
                node=node,
                time_text=time_text,
                unit=unit_str,
                time_count=time_count,
                time_unit=time_unit
            )
            cmd += comment_line + " " + " ".join(def_parts + gprint_parts)
            logger.debug(f"Executing command: {cmd}")
            x = os.system(cmd + " > /dev/null 2>&1")
            if x != 0:
                logger.error(f"could not generate graph for node: {node}; error code: {x}")
            
# --------------------------------------------------------------------------------------------------

if __name__ == '__main__':
    current_file_path = os.path.realpath(__file__)
    current_file_name = os.path.basename(current_file_path)

    cfg = config.InitManager(current_file_name)
    
    logger.info(f'---------- starting {current_file_name} ----------') 
    bg = BuildGraphics(cfg)
    bg.MakeAllGraphs()
    while(1):
        logger.info("brumbrumbrum schleife dreh dich rum")
        time.sleep(10)
