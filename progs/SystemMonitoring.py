import logging
from datetime import datetime
import psutil
import threading
import time
import platform
import os
import DataStore as ds

logger = logging.getLogger(__name__)


# The SystemMonitoring class is used for monitoring and managing system resources.
class SystemMonitoring:
    def __init__(self, cfg):
        self.cfg = cfg
        self.service = self.cfg['__Dstore__']
        self.sysmonsleep = self.cfg['SystemMonitorSleep']
        self.cpumonsleep = self.cfg['CPU_MonitorSleep']
        self.ethmonsleep = self.cfg['ETH_MonitorSleep']
        self.sdxmonsleep = self.cfg['SDX_MonitorSleep']
        services = {
            "sys_service": "~system",
            "cpu_service": "~cpustats",
            "eth_service": "~eth0",
            "sda_service": "~sda",
            "sdb_service": "~sdb"
        }
        for attr, key in services.items():
            setattr(self, attr, cfg['__Dstore__'].ds[key]['__Service__']) 
        
        self.cpu_temp = get_temps()  # Dictionary
        self.du = psutil.disk_usage("/")

    def _system_monitor(self, stop_event: threading.Event):
        logger.debug("_monitoring_thread started")
        data = {"~system": {}}
        while not stop_event.is_set():
            self.cpu_temp = get_temps()  # Dictionary
            self.du = psutil.disk_usage("/")
            data["~system"]["disk_total"] = self.du[0]
            data["~system"]["disk_used"] = self.du[1]
            data["~system"]["disk_free"] = self.du[2]
            data["~system"]["disk_percent"] = self.du[3]
            now = time.time()
            data["~system"]["uptime_sys"] = int(now - psutil.boot_time())
            data["~system"]["uptime_app"] = int(now - self.sys_service.pick("starttime_ticks", "CURRENT_DATA")[1])
            self.sys_service.handle_DataSet(data)
            if stop_event.wait(self.sysmonsleep):
                break            
            
    def _cpu_monitor(self, stop_event: threading.Event):
        logger.debug("_cpu_monitoring_thread started")
        data = {"~cpustats": {}}
        while not stop_event.is_set():
            data["~cpustats"]["CPU_load_1m"], data["~cpustats"]["CPU_load_5m"], data["~cpustats"]["CPU_load_15m"] = get_loadavg()
            self.cpu_temp = get_temps()  # Dictionary
            data["~cpustats"]["coretemp"] = self.cpu_temp["cpu_thermal"][0][1]
            self.cpu_service.handle_DataSet(data)
            if stop_event.wait(self.cpumonsleep):
                break            

    def _eth_monitor(self, stop_event: threading.Event):
        logger.debug("eth_monitoring_thread started")
        tx = 0
        rx = 0
        data = {"~eth0": {}}
        while not stop_event.is_set():
            if platform.system()=='Linux':
                net_io = psutil.net_io_counters(pernic=True)
                eth0_stats = net_io["eth0"]
                data["~eth0"]["eth_Tx"] = int(eth0_stats.bytes_sent) # Convert to MB
                data["~eth0"]["eth_Rx"] = int(eth0_stats.bytes_recv) # Convert to MB
            else:
                data["~eth0"]["eth_Tx"] = tx
                data["~eth0"]["eth_Rx"] = rx
                tx += 1
                rx += 1
            self.eth_service.handle_DataSet(data)
            if stop_event.wait(self.ethmonsleep):
                break            

    def _sdx_monitor(self, stop_event: threading.Event):
        logger.debug("sdx_monitoring_thread started")
        tx = 0
        rx = 0
        sda_data = {"~sda": {}}
        sdb_data = {"~sdb": {}}
        while not stop_event.is_set():
            if platform.system()=='Linux':
                # Disk-I/O-Zähler seit Systemstart (alle Geräte kumuliert)
                disk_io = psutil.disk_io_counters(perdisk=True)
                sda = disk_io.get("sda") #this is the backup drive
                sdb = disk_io.get("sdb") #this is the samba drive
                try:
                    sda_data["~sda"]["read"] = sda.read_bytes
                    sda_data["~sda"]["write"] = sda.write_bytes
                    sdb_data["~sdb"]["read"] = sdb.read_bytes
                    sdb_data["~sdb"]["write"] = sdb.write_bytes
                except Exception as e:
                    sda_data["~sda"]["read"] = 0
                    sda_data["~sda"]["write"] = 0
                    sdb_data["~sdb"]["read"] = 0
                    sdb_data["~sdb"]["write"] = 0
            else:
                sdb_data["~sdb"]["read"] = 2 * tx
                sdb_data["~sdb"]["write"] = rx
                sda_data["~sda"]["read"] = tx
                sda_data["~sda"]["write"] = 2 * rx
                tx += 1
                rx += 1
            self.sda_service.handle_DataSet(sda_data)
            self.sdb_service.handle_DataSet(sdb_data)
            if stop_event.wait(self.sdxmonsleep):
                break            

    def hotCPU(self):
        print(f'!!!! A L A R M -> CPU is to hot !!!')
        pass

def get_loadavg():
    if hasattr(os, "getloadavg"):
        load1, load5, load15 = os.getloadavg()
        return load1, load5, load15
    else: 
        logger.error("load average is not available on this system")
        load1, load5, load15 = 1, 2, 3
        return load1, load5, load15

    
def get_temps():
    if platform.system()=='Linux':
        return psutil.sensors_temperatures(fahrenheit=False)
    else:
        cpu_temp = {
            "cpu_thermal": [
            ["core1", 22.22],  # Index 0: Ein Listenelement mit 2 Werten
            ]
        }
        return cpu_temp
