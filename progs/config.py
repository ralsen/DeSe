#!/usr/bin/env python3 xxx
# -*- coding: utf-8 -*-
import logging
import yaml
import socket
import datetime
import os
import time
import platform
from pathlib import Path


import DataStore as ds
import DeSeTimer as dt
import budi as bd
from threadmanager import ThreadManager
from weather import Weather
from SystemMonitoring import SystemMonitoring
import mailit as mi

logger = logging.getLogger(__name__)

class InitManager:
    def __init__(self, progname: str):
        self.ini = {}
        self.progname = progname
        self.load_init()
        
    def get_external_ip(self) -> str:
        try:
            # create a dummy socket to determine the external IP
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))  # Google DNS as target
            ip_address = s.getsockname()[0]
            s.close()
            return ip_address
        
        except Exception as e:
            return f"Fehler: {e}"

    def load_init(self):
        ini = self.ini
        current_dir = Path.cwd()
        self.ini['wd'] = current_dir
        config_path = os.path.join(current_dir, 'yml', 'config.yml')
        diagram_path = os.path.join(current_dir, 'yml', 'diagrams.yml')
        
        with open(config_path, 'r') as ymlfile:
            confyml = yaml.safe_load(ymlfile)

        with open(diagram_path, 'r') as diaymlfile:
            self.dias = yaml.safe_load(diaymlfile)

        ini['dias'] = self.dias
        ini['StartTime'] = str(datetime.datetime.now())
        ini['confyml'] = confyml
        ini['LogPath'] = current_dir / confyml['pathes']['LOG']
        ini['DataPath'] = current_dir  / confyml['pathes']['DATA']
        ini['RRDPath'] = current_dir / confyml['pathes']['RRD']
        ini['YMLPath'] = current_dir / confyml['pathes']['YML']
        ini['PNGPath'] = current_dir / confyml['pathes']['PNG']
        ini['TMPPath'] = current_dir / confyml['pathes']['TEMPLATE']
        ini['DeSePort'] = confyml['Communication']['DevServerPort']
        ini['DeSeName'] = confyml['Communication']['DevServerName']
        ini['debugdatefmt'] = confyml['debug']['datefmt']
        ini['logSuffixes'] = confyml['suffixes']['log']
        ini['logSuffix'] = datetime.datetime.now().strftime(ini['logSuffixes'])
        ini['dataSuffix'] = confyml['suffixes']['data']
        ini['hirestime'] = confyml['debug']['hirestime']
        ini['SystemMonitorSleep'] = confyml['Timers']['SystemMonitorSleep']
        ini['ETH_MonitorSleep'] = confyml['Timers']['_ETH_MonitorSleep']
        ini['SDX_MonitorSleep'] = confyml['Timers']['_SDX_MonitorSleep']
        ini['CPU_MonitorSleep'] = confyml['Timers']['_CPU_MonitorSleep']
        ini['getWeatherInterval'] = confyml['Timers']['getWeatherInterval']
        ini['mainloop_sleep'] = confyml['Timers']['mainloop_sleep']
        ini['humanTimestamp'] = confyml['misc']['humanTimestamp']
        ini['test_webserver'] = confyml['misc']['test_webserver']
        ini['do_graphics'] = confyml['misc']['do_graphics']
        ini['Mailing'] = confyml['debug']['Mailing']
        ini['MyName'] = socket.gethostname()
        ini['My_IP'] = self.get_external_ip()
        system = platform.system()
        ini['System'] = system
        ini['ProgramName'] = self.progname
        ini['Tasks'] = confyml['DeSeTask'][system]
        ini['__mail__'] = mi.MailIt(ini)
        
        logging.basicConfig(
            level=getattr(logging, confyml['misc']["loglevel"].upper(), logging.INFO), # INFO is default  
            #level=logging.DEBUG, 
            format='%(asctime)s :: %(levelname)-7s :: [%(name)+16s] [%(lineno)+3s] :: %(message)s',
            datefmt=ini['debugdatefmt'],
            handlers=[
                logging.FileHandler(f"{ini['LogPath']}/{self.progname[:-3]}_{socket.gethostname()+ini['logSuffix']}.log"),
                logging.StreamHandler()
            ])

        if "module_loglevels" in confyml:
            for module_name, level_str in confyml["module_loglevels"].items():
                level = getattr(logging, level_str.upper(), None)
                if isinstance(level, int):
                    logging.getLogger(module_name).setLevel(level)
            
        logger.info("")
        logger.info(f"---------- starting {self.progname} at {ini['StartTime']} ----------")

        tm = ThreadManager()  
        ini['__ThreadManager__'] = tm     

        #ini['D-store'] = ds.DS(ini, f"{ini['YMLPath']}/{ini['confyml']['files']['DATASTORE_YML']}") ######
        #ini['stores'] = {}
        #ini['stores']['devices'] = ds.DS(ini, f"{ini['YMLPath']}/device_stores.yml") ######
        ini['__Dstore__'] = ds.DS(ini, f"{ini['YMLPath']}/datastore.yml") ######
        ini["__weather__"] = weather_thread = Weather(ini)
        ini["__system__"] = system_monitor_thread = SystemMonitoring(ini)
        ini['__ThreadManager__'].start("CPU", target=system_monitor_thread._cpu_monitor)
        ini['__ThreadManager__'].start("ETH", target=system_monitor_thread._eth_monitor)
        ini['__ThreadManager__'].start("sdx", target=system_monitor_thread._sdx_monitor)
        ini['__ThreadManager__'].start("system", target=system_monitor_thread._system_monitor)
        ini['__ThreadManager__'].start("weather", target=weather_thread.run)
        ini["__DeSeTimer__"] = dt.DeSeTimer(ini)
        ini["__Graphic__"] = bd.BuildGraphics(ini)

        data = {'~system': {}}
        data["~system"]["MyName"] = ini['MyName']
        data["~system"]["My_IP"] = ini['My_IP']
        data["~system"]["starttime_ticks"] = int(time.time())
        data["~system"]["starttime_app"] = datetime.datetime.fromtimestamp(time.time()).strftime(('%d.%m.%Y %H:%M:%S'))
        data["~system"]["uptime_app"] = 0
        data["~system"]["uptime_sys"] = 0
        data["~system"]["ProgName"] = self.progname
        ini['__Dstore__'].ds['~system']['__Service__'].handle_DataSet(data)

        ini['__ThreadManager__'].start("SystemMonitor", target=system_monitor_thread._system_monitor)
        logger.info(f"Initialisation complete")
