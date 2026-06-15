import logging
from datetime import datetime
import time
import os
import sys
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

import config as cfg

logger = logging.getLogger(__name__)


class DeSeTimer:
    def __init__(self, cfg):
        self.cfg = cfg
        if 'Tasks' not in self.cfg or self.cfg['Tasks'] is None:
            logger.error("No tasks found in config")
            return
        for task in cfg['Tasks']:
            self.cfg['__ThreadManager__'].start(task[0], target=self._task_thread, args=(task,))
        self.cfg['__ThreadManager__'].start("__notify_thread__", target=self.__notify_thread__)
        logger.info("DeSeTimer started all tasks")

    def _task_thread(self, stop_event, task):
        while not stop_event.is_set():
            err = os.system(task[0])
            if err != 0:
                logger.error(f"result from: {task[0]} -> {err}")
            if stop_event.wait(task[1]):
                break
        pass

    def __notify_thread__(self, stop_event):
        outer_self = self
        class NotifyHandler(FileSystemEventHandler):
            def on_any_event(self, event):
                if event.is_directory:
                    return

                filename = os.path.basename(event.src_path)

                # Liste von Mustern/Endungen, die ignoriert werden sollen
                ignore_suffixes = ("~", ".swp", ".swx", ".tmp", ".bak")
                ignore_prefixes = (".",)   # versteckte Dateien, z.B. ".filename.swp"

                if filename.endswith(ignore_suffixes) or filename.startswith(ignore_prefixes):
                    return

                if event.event_type == 'modified':
                    logger.info(f"something changed in config directory {outer_self.cfg['YMLPath']}")
                    logger.info(f"Datei: {filename}, Ereignis: {event.event_type}")
                    logger.info("terminating everything!!!")
                    stop_event.set()
                    outer_self.cfg['__ThreadManager__'].stop_all()
                
        event_handler = NotifyHandler()
        observer = Observer()
        observer.schedule(event_handler, self.cfg['YMLPath'], recursive=False)
        observer.start()

        try:
            while not stop_event.is_set():
                time.sleep(0.5)
        finally:
            observer.stop()
            observer.join()
            logger.info("Exiting program now. Bye!")
            os._exit(0)
