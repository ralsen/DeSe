import xml.etree.ElementTree as Weather
import logging
import json
import datetime
import requests
import threading

from DataStore import Service
#import DataStore as ds

logger = logging.getLogger(__name__)
logging.getLogger('urllib3').setLevel(logging.WARNING)

class Weather:
    """
    The line `dirnames = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW',
    'W', 'WNW', 'NW', 'NNW']` is creating a list called `dirnames` that contains the names of different
    wind directions. Each element in the list represents a specific wind direction, starting from North
    (N) and going clockwise.
    """
    def __init__(self, cfg: dict):
        self.dirnames = ['N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW']
        self.cfg = cfg
        self.wait = self.cfg['getWeatherInterval']
        cfg['__Dstore__'].append('weather', 'Weather')

    def run(self, stop_event: threading.Event):
        while not stop_event.is_set():
            try:
                res = requests.get ('http://api.openweathermap.org/data/2.5/weather?q=Langenhagen,DE&appid=292f322d8c2231804fa357041a30a73e&units=metric&mode=json')
            except Exception as e:
                logger.error(f"cant get the weather data: {e}")

            # so jetzt schreiben wir das ganze in eine Datei, falls andere das auch gebrauchen koennen
            data = json.loads(res.text)
            jsdata = {
                'json': res.text,
                'Temperature': data['main']['temp'],
                'Temperature_min': data['main']['temp_min'],
                'Temperature_max': data['main']['temp_max'],
                'Feels_like': data['main']['feels_like'],
                'Humidity': data['main']['humidity'],
                'Pressure': data['main']['pressure'],
                'Wind_Speed': data['wind']['speed'],
                'Wind_Direction': data['wind']['deg'],
                'Wind_DirName': self.dirnames[round(data['wind']['deg'] / (360.0 / len(self.dirnames))) % len(self.dirnames)],
                'Sunrise': datetime.datetime.fromtimestamp(data['sys']['sunrise']).strftime('%H:%M:%S'),
                'Sunset': datetime.datetime.fromtimestamp(data['sys']['sunset']).strftime('%H:%M:%S'),
            }
            dataset = {'weather': jsdata}
            self.cfg['__Dstore__'].ds['weather']['__Service__'].handle_DataSet(dataset)
            if stop_event.wait(self.wait):
                break