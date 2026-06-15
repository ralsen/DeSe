import logging
from datetime import datetime
import threading
import time
import os
from inotify_simple import INotify, flags

import config as cfg

logger = logging.getLogger(__name__)

class DeSeTimer:
    def __init__(self, cfg):
        self.cfg = cfg
        if 'Tasks' not in self.cfg or self.cfg['Tasks'] == None:
            logger.error("No tasks found in config")
            return
        for task in cfg['Tasks']:
            self.cfg['__ThreadManager__'].start(task[0], target=self._task_thread, args=(task,))
        self.cfg['__ThreadManager__'].start("_notify_thread", target=self._notify_thread)
        logger.info("DeseTimer started all tasks")
   
    def _task_thread(self, stop_event, task):
        while not stop_event.is_set():
            #logger.debug(f"running task: {task[0]}")
            err = os.system(task[0])
            if err != 0:
                logger.error(f"result from: {task[0]} -> {err}")
            if stop_event.wait(task[1]):
                break
        pass

    def _notify_thread(self, stop_event):
        watch_flags = (
            flags.ACCESS | flags.ATTRIB | flags.CLOSE_WRITE | flags.CLOSE_NOWRITE |
            flags.CREATE | flags.DELETE | flags.DELETE_SELF | flags.MODIFY |
            flags.MOVE_SELF | flags.MOVED_FROM | flags.MOVED_TO | flags.OPEN
        )
        inotify = INotify()
        wd = inotify.add_watch(self.cfg['YMLPath'], watch_flags)            # Placeholder for notification handling logic
        while True:
            for event in inotify.read():
                flag_names = [str(f) for f in flags.from_mask(event.mask)]
                if event.name:
                    logger.info(f"Datei: {event.name}, Ereignis: {flag_names}")
                    #self.cfg['__ThreadManager__'].stop_all()
                    #os._exit(0)
            time.sleep(1)   