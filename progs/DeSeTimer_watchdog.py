import logging
from datetime import datetime
import threading
import time
import os
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
        self.cfg['__ThreadManager__'].start("_notify_thread", target=self._notify_thread)
        logger.info("DeSeTimer started all tasks")

    def _task_thread(self, stop_event, task):
        while not stop_event.is_set():
            err = os.system(task[0])
            if err != 0:
                logger.error(f"result from: {task[0]} -> {err}")
            if stop_event.wait(task[1]):
                break
        pass

    def _notify_thread(self, stop_event):
        class NotifyHandler(FileSystemEventHandler):
            def on_any_event(self, event):
                if not event.is_directory:
                    logger.info(f"Datei: {os.path.basename(event.src_path)}, Ereignis: {event.event_type}")

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