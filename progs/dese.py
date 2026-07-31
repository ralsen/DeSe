#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# MACMAC

#   Todos:
#       -   mdo_POST should distinguish between normal Datastore data and other Information or Commands
#       -   possible Commands are: restart, remove a datastore, set parameters for a specified Datastore or for dese itself
#       -   are there other possibilities as URL? how do the Nodes send?
###############################################################
#from http.server import HTTPServer, BaseHTTPRequestHandler
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

import time
import threading
import logging 
import os

import webserv as ws
import config

logger = logging.getLogger(__name__)

if __name__ == '__main__':
    current_file_path = os.path.realpath(__file__)
    current_file_name = os.path.basename(current_file_path)

    cfg = config.InitManager(current_file_name).ini
    cfg['__mail__'].mailit(f"message from {cfg['MyName']}", f"Starting {cfg['ProgramName']} on {cfg['MyName']} with IP: {cfg['My_IP']}")
    
    ServerName = f"{cfg['MyName']}.local"
    ServerPort = cfg['DeSePort']
    try:
        ws.webserverHandler.set_cfg(ws.webserverHandler, cfg)
        logger.info(f'Trying to start Device server: http://{ServerName}:{ServerPort}')
        #server = ThreadingHTTPServer((ServerName, ServerPort), ws.webserverHandler)
        server = ThreadingHTTPServer(('', ServerPort), ws.webserverHandler)
    except Exception as err:
        logger.error(f"Could not listen on http://{ServerName}:{ServerPort} -> {err}")
        logger.error("!!! Terminate program !!!")
        cfg['__ThreadManager__'].stop_all()
        exit()

    logger.info(f"Starting DeSe-Server on {ServerName}:{ServerPort}.")
    threading.Thread(target=server.serve_forever, daemon=True).start()    
    
    #print(webserverHandler.getDeviceInfo(True))
    old_x = []

    try:
        while True:
            x = cfg['__ThreadManager__'].get_all()
            if x != old_x:
                new_threads = set(x) - set(old_x)   # neu dazugekommen
                mis_threads = set(old_x) - set(x)    # weggefallen
                logger.info(f"{len(x)} active Threads:")
                logger.info(f"New thread(s):     {new_threads}")
                if mis_threads:
                    logger.info(f"Removed thread(s): {mis_threads}")
                logger.info(f"all thread(s):     {x}")
                old_x = x
            if cfg['do_graphics']:
                cfg['__Graphic__'].MakeAllGraphs()
            if cfg['test_webserver']:
                ws.test_webserver_handler()
            time.sleep(cfg['mainloop_sleep'])
    except KeyboardInterrupt:
        logging.info("CTRL+C pressed – terminate Threads…")
        cfg['__ThreadManager__'].stop_all()

