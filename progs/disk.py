import time
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

# Eigener Ereignis-Handler
class MeinHandler(FileSystemEventHandler):
    def on_created(self, event):
        print(f"Erstellt: {event.src_path}")
    def on_deleted(self, event):
        print(f"Gelöscht: {event.src_path}")
    def on_modified(self, event):
        print(f"Geändert: {event.src_path}")
    def on_moved(self, event):
        print(f"Verschoben: von {event.src_path} nach {event.dest_path}")

# Beobachter starten
if __name__ == "__main__":
    pfad = "/Users/ralphfollrichs/Projects/MAC_DaBo64/yml"  # z.B. "./" für aktuelles Verzeichnis
    event_handler = MeinHandler()
    observer = Observer()
    observer.schedule(event_handler, path=pfad, recursive=True)
    observer.start()

    print(f"Überwache Änderungen in: {pfad}")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
    