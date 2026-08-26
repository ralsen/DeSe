from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler

import urllib.parse
import traceback
import logging 
import json
import time
import copy
import subprocess
import datetime

from flask import Flask, jsonify
from flask_cors import CORS

import tools as tl

app = Flask(__name__)
CORS(app, origins=['http://localhost:8080'])  # Hier die erlaubte Origin anpassen

logger = logging.getLogger(__name__)

class webserverHandler(BaseHTTPRequestHandler):
    def make_public_dict(self, obj: dict) -> dict:
        return self.filter_dict(obj, "__", keep_prefix=False)

    def filter_dict(self, data: dict, filter_prefix: str, keep_prefix: bool = True) -> dict:
        if not isinstance(data, dict):
            return data

        filtered_data = {}

        for key, value in data.items():
            if keep_prefix:
                if key.startswith(filter_prefix):
                    # Nicht weiter filtern – einfach den ganzen Zweig übernehmen
                    filtered_data[key] = copy.deepcopy(value)
                elif isinstance(value, dict):
                    # Reinschauen, ob es tiefer was mit dem Prefix gibt
                    nested = self.filter_dict(value, filter_prefix, keep_prefix=True)
                    if nested:
                        filtered_data[key] = nested
            else:
                if not key.startswith(filter_prefix):
                    if isinstance(value, dict):
                        nested = self.filter_dict(value, filter_prefix, keep_prefix=False)
                        if nested:
                            filtered_data[key] = nested
                    else:
                        filtered_data[key] = value  # primitive Werte beibehalten

        return filtered_data if filtered_data else None

    def log_message(self, format, *args):
        # dont bore me with stupid log-messages
        return   
     
    def set_cfg(self, cfg: dict):
        self.cfg = cfg 
        logger.debug(f"set_cfg called with cfg: {cfg}")
        

    def fetch_rrd(self, filename, start="-1w", end="now", cf="AVERAGE"):
        logger.debug(f"Fetching RRD data: file={filename}, start={start}, end={end}, cf={cf}")
        cmd = [
            "rrdtool",
            "fetch",
            filename,
            cf,
            "-s", start,
            "-e", end,
            "--resolution", "300"
        ]

        result = subprocess.run(cmd, capture_output=True, text=True)
        logger.debug(f"RRD command executed: {' '.join(cmd)}")
        if result.returncode != 0:
            return {"error": result.stderr}

        lines = result.stdout.strip().split("\n")
        header = lines[0].split()

        data = []

        for line in lines[2:]:
            if ":" not in line:
                continue

            ts, values = line.split(":")

            row = {
                "timestamp": int(ts.strip()),
                "datetime": datetime.datetime.fromtimestamp(
                    int(ts.strip())
                ).isoformat()
            }

            values = values.split()

            for i, v in enumerate(values):
                if v.lower() == "nan":
                    row[header[i]] = None
                else:
                    try:
                        row[header[i]] = float(v)
                    except:
                        row[header[i]] = None

            data.append(row)

        return data
                        
    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        #logger.debug(f"parsed_path: {self.headers}")
        path = parsed_path.path
        query_components = urllib.parse.parse_qs(parsed_path.query)
        try:
            #logger.debug(f"receiving: {parsed_path}")
            if path.endswith("/sendDevInfo"):
                message = self.getDeviceInfo()
            elif path.endswith("/sendDevList"):
                message = self.getDeviceList()
            elif path.endswith("/sendDiaList"):
                message = self.getDiaList()
                message = self.cfg['dias'] #nur zum Testen, dass es funktioniert
            elif path.endswith("/doCommand"): #koennte z.B. so gehen http://192.168.2.2:8080/doCommand?param1=value1&param2=value2
                message = self.doCommand(query_components)
            elif path.endswith("/sendDSInfo"): #koennte z.B. so gehen http://192.168.2.2:8080/doCommand?param1=value1&param2=value2
                ds_copy = self.cfg['__Dstore__'].ds
                current_ds = self.filter_dict(ds_copy, "CURRENT_DATA", keep_prefix=False)
                message = self.make_public_dict(current_ds)
            elif path.endswith("/sendCFG"): #koennte z.B. so gehen http://192.168.2.2:8080/doCommand?param1=value1&param2=value2
                ds_copy = self.cfg['__Dstore__'].cfg
                current_ds = self.filter_dict(ds_copy, "__", keep_prefix=False)
                message = self.make_public_dict(current_ds)
            elif path.endswith("/sendCFG"): #koennte z.B. so gehen http://192.168.2.2:8080/doCommand?param1=value1&param2=value2
                ds_copy = self.cfg['__Dstore__'].cfg
                current_ds = self.filter_dict(ds_copy, "CURRENT_DATA", keep_prefix=False)
                message = self.make_public_dict(current_ds)
                logger.debug(message)
            elif path.endswith("/sendRRDHistory"):
                # Parameter aus den Query-Schlüsseln ziehen (query_components liefert Listen zurück)
                filename = f"{self.cfg['RRDPath']}/" + query_components.get('file', ['ShellyPStripG4-98A3167B61A0.rrd'])[0]
                start = query_components.get('start', ['-1w'])[0]
                end = query_components.get('end', ['now'])[0]
                
                logger.debug(f"got RRD request: file={filename}, start={start}, end={end}")
                
                # Lokale Funktion aufrufen, um RRD auszulesen
                message = self.fetch_rrd(filename, start, end)
            else:
                self.send_response(400)
                self.send_header('Content-type', 'text/plain')
                self.end_headers()
                self.wfile.write(b"don't boring me with stupid requests like: " + self.path.encode())
                return
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
            self.send_header('Access-Control-Allow-Headers', 'Content-Type')
            self.end_headers()
            self.wfile.write(json.dumps(message).encode())           
            logger.debug(f"Response sent for path: {self.path} with message: {message}")
            return

        except IOError:
            self.send_error(404, f"File not found {self.path}")

    def do_POST(self):
        self.service = self.cfg['__Dstore__'].ds
        #logger.debug(f"POST Headers: {self.service}")
        try:
            content_length = int(self.headers['Content-Length']) # <--- Gets the size of data
            post_data = self.rfile.read(content_length) # <--- Gets the data itself
            dict_str = post_data.decode('UTF-8')
            data = json.loads(dict_str)
            #logger.debug(f"receiving: {data}")
            self.send_response(301)
            self.send_header('Content-Type', 'text/html')
            self.end_headers()
            output = '' + '<html><body>'
            output += f'<h2> Okay, got your data at: {str(time.time())}</h2>'
            output += '</body></html>'
            self.wfile.write(output.encode())
            try:
                data['name']
                data['Type']
            except Exception as err:
                logger.info(f"no 'name' or 'Type' specified: {err}\nin this dataset\n{data}")
            finally:
                logger.debug(f"received data from : {data['name']}")
                if data['name'] not in self.service:
                    self.cfg['__Dstore__'].append(data['name'], data['Type'])
                dataset = {data['name']: data}
                self.service[data['name']]['__Service__'].handle_DataSet(dataset)
        except Exception as err:
            self.send_error(404, f'Not part of the Datastore: {err}')
            logger.warning(f"Not part of the Datastore: {err}")
    
    def doCommand(self, params):
        logger.debug(f"receiving: {params}")
        action = params.get('action', [''])[0]  # Default to empty string if not found
        res = {'time': str(datetime.datetime.now()), 'RS': 'everything done. ', 'action': action}
        logger.debug('later we will do fancy things here')
        return res

    def getDeviceInfo(self) -> dict:
        valuelist = {}
        for store in self.cfg['__Dstore__'].ds:
            valuelist[store] = {'info': {}}
            try:
                store_ds = self.cfg['__Dstore__'].ds[store]
                for web in store_ds['Commons']['__WEB__']:
                    newVal = str(store_ds[web[1]][web[2]])
                    if web[2] == 'CURRENT_DATA':
                        try:
                            x = store_ds[web[1]]['DECIMALS']
                            resstr = str(round(float(newVal), x))
                        except Exception:
                            resstr = str(newVal)
                            pass #No DECIMALS                   
                    else:
                        resstr = str((newVal))
                    valuelist[store]['info'][web[0]] = resstr
            except Exception as err:
                #no __WEB__ no fun ;-)
                line_number = 0
                stack_trace = traceback.extract_tb(err.__traceback__)
                line_number = stack_trace[-1].lineno
                #logger.debug(f"no Web no fun: {err} in {line_number}")
            valuelist[store]['stat'] = {
                'TIMEOUT': str(store_ds['Commons']['TIMEOUT']),
                'Active':  str(store_ds['Commons']['Active']),
                'Counter': tl.format_value(store_ds['Commons']['Counter'], mode="count"),
                'lastUPD': str(store_ds['Commons']['lastUPD']).split('.', 1)[0]
            }
        #print("fertich")
        return dict(sorted(valuelist.items(), key=lambda item: item[0]))

    def getDiaList(self) -> list:
        DevList = []
        for store in self.cfg['__Dstore__'].ds:
            DevList.append(self.cfg['__Dstore__'].ds[store]['Commons']['Store'])
        return DevList

    def getDeviceList(self) -> list:
        DevList = []
        for store in self.cfg['__Dstore__'].ds:
            DevList.append(self.cfg['__Dstore__'].ds[store]['Commons']['Store'])
        return DevList

def test_webserver_handler():
    # Test the webserverHandler class
    #handler = webserverHandler()
    #assert handler is not None
    #assert handler.cfg is not None
    data = {'name': 'Wohnzimmer_2-083A8DE3E776', 
            'IP': '192.168.2.81', 
            'Version': '5.0e', 
            'Hardware': 'NODEMCU', 
            'Network': 'janzneu', 
            'APName': 'ESPnet', 
            'MAC': '08:3A:8D:E3:E7:76', 
            'TransmitCycle': '5', 
            'MeasuringCycle': '150', 
            'Hash': '9772b3', 
            'Size': '332', 
            'PageReload': '10', 
            'Server': '192.168.2.87', 
            'Port': '8080', 
            'uptime': '135', 
            'delivPages': '0', 
            'goodTrans': '2', 
            'badTrans': '23', 
            'LED': '1', 
            'WiFi': '-43', 
            'Type': 'DS1820-1', 
            'Adress_0': '28cc7abb00000029', 
            'Value_0': '22.75'}
    #url = f"http://localhost:{ServerPort}/test"
    #r = requests.post(url, json=data)  # automatisch JSON + Header setzen
    #print(r.status_code, r.text)    

