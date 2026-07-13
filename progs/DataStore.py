#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# test

import config as cfg
import logging
import time
import datetime
import threading
import os
import subprocess
import yaml

logger = logging.getLogger(__name__)

def parse_topic(s: str):
    s = s.lstrip("§")
    if "/" not in s:
        raise ValueError("Expecting Format '§Storegroup/Storename'")
    return s.split("/", 1)

system_part, weather_part = parse_topic("§system/weather")
print(system_part, weather_part)  # system weather

# The self class is a Python class that reads store definitions from a YAML file and generates stores
# based on the templates provided.
class DS:
    def __init__(self, cfg: dict, StoreDefs: str):
        self.ds = dict()
        self.cfg = cfg
        logger.info(f"using store definitions from: {StoreDefs}")
        with open(StoreDefs, 'r', encoding="utf-8") as file:
            StoreYML = yaml.safe_load(file)
        self.Stores = StoreYML
        if 'generate_stores' in StoreYML:
            try:
                for Store, template in StoreYML['generate_stores'].items():
                    self.append(Store, template)
            except Exception as err:
                logger.error(f"Error building stores: {err}")
                pass

    def append(self, Store: str, templateName: str):
        template = self.Stores['DataStores'][templateName]
        logger.info(f'Building Store for: {Store} with template: {templateName}')
        self.ds[Store] = dict()
        for ShelfTag, x in template.items():
            self.ds[Store][ShelfTag] = dict()
            self.ds[Store][ShelfTag]['CURRENT_DATA'] = 0
            self.ds[Store][ShelfTag]["lastUPD"] = None                                                           
            try:
                for DataBox, Value in x.items():
                    self.ds[Store][ShelfTag][DataBox] = Value
            except Exception:
                pass
            if ShelfTag == 'Commons':       # initialize Commons
                self.ds[Store]['Commons']['Store'] = Store
                self.ds[Store]['Commons']['__header'] = 'time'
                if 'Active' in self.ds[Store]['Commons']:
                    self.ds[Store]['Commons']['Active'] = True
                self.ds[Store]['Commons']['Flag'] = False
                self.ds[Store]['Commons']['Counter'] = 0
                self.ds[Store]['Commons']['lastUPD'] = ''
                self.ds[Store]['Commons']['initTime'] = str(datetime.datetime.now())
            if ShelfTag != 'Commons':       # Commons are not part of the csv-header  
                try:
                    if x['CSV_MODE'] != 'NONE':
                        self.ds[Store]['Commons']['__header'] += ',' + ShelfTag
                        self.ds[Store][ShelfTag]['CSV_MODE_DATA'] = 0
                except Exception:
                    pass
        self.ds['~DaBo']['stores']['CURRENT_DATA'] += 1
        self.ds[Store]['__Service__'] = Service(self.cfg, self.ds, Store) # start store handling

#??? {'CURRENT_DATA': 0, 'lastUPD': None, 'CSV_MODE': 'CHANGE', 'CSV_MODE_DATA': 0} ???
# The `Service` class is responsible for handling data, monitoring for timeouts, merging data from
# different sources, and writing data to a CSV file or a database.
class Service:
    MyName = ''
    def __init__(self, cfg: dict, ds: dict, StoreName: str):
        self.cfg = cfg
        self.ds = ds
        self.MyName = StoreName
        try:
            for index, mergeStr in enumerate(self.ds[self.MyName]['Commons']['__MERGE__']):
                logger.info(f"   merge: {index} - {mergeStr}")
                #threading.Thread(target=self._merge_thread, args=(mergeStr[0], index,),daemon=True).start()
                self.cfg['__ThreadManager__'].start(f"_merge_thread_{index}", target=self._merge_thread, args=(mergeStr[0], index))
        
        except Exception as err:
            logger.info(f"no merge for store: {self.MyName}")
            pass    
        self.cfg['__ThreadManager__'].start(f"monitoring for {StoreName}", target=self.__monitoring_thread__, args=())

    def __monitoring_thread__(self, stop_event: threading.Event):
        while not stop_event.is_set():
            if(self.ds[self.MyName]['Commons']['TIMEOUT']):
                self.ds[self.MyName]['Commons']['TIMEOUT'] -= 1
                if(not self.ds[self.MyName]['Commons']['TIMEOUT']):
                    self.ds[self.MyName]['Commons']['Active'] = False
                    logger.error(f'Message missed: {self.MyName}')
                    self.cfg['__mail__'].mailit(f"message from Datastore on {self.cfg['MyName']}", f'Message missed: {self.MyName}')
                    #self.mi.mailit(f'Message missed: {self.MyName}')
            if stop_event.wait(1):
                break
    def setCallBack(self, shelf: str, function: callable):
        self.ds[self.MyName][shelf]['__CaBa_1'] = function
        logger.info(f'callBack for Shelf "{shelf}" in Store "{self.MyName}" is set.')

    def handle_DataSet(self, DataSet: dict):
        if self.cfg['humanTimestamp']:
            if self.cfg['hirestime']:
                timeStamp = datetime.datetime.fromtimestamp(time.time()).strftime(('%d.%m.%Y %H:%M:%S.%f'))
            else:
                timeStamp = datetime.datetime.fromtimestamp(time.time()).strftime(('%d.%m.%Y %H:%M:%S'))
        else:
            if self.cfg['hirestime']:
                timeStamp = str(time.time())
            else:
                timeStamp = str(int(time.time()))
        for key in DataSet.keys():
            try:
                self.handleData(DataSet[key], timeStamp)
            except Exception as err:
                logger.error(f'receiving invalid DataSet: {key} - {type(err)} - {DataSet}')

    def handle_CAN(self, msg: str):
        try:
            decoded_DBC = self.cfg['CAN_dbc'].decode_message(msg.arbitration_id, msg.data)
        except Exception as err:
            logger.error(f'receiving unknown CAN-Bus message-ID: {str(msg.arbitration_id)} -> {err}')
            return
        if self.cfg['humanTimestamp']:
            if self.cfg['hirestime']:
                timeStamp = datetime.datetime.fromtimestamp(msg.timestamp).strftime(('%d.%m.%Y %H:%M:%S.%f'))
            else:
                timeStamp = datetime.datetime.fromtimestamp(msg.timestamp).strftime(('%d.%m.%Y %H:%M:%S'))
        else:
            if self.cfg['hirestime']:
                timeStamp = str(msg.timestamp)
            else:
                timeStamp = str(int(msg.timestamp))
        self.handleData(decoded_DBC, timeStamp)

    def handleData(self, DataSet: dict, timeStamp: int):
        
        log = False
        while (self.ds[self.MyName]['Commons']['Flag']):
            if not log:
                logger.info(f'waiting for Flag to be False in handleData() for {self.MyName}')
                log = True
            time.sleep(0.1)
            pass
        if log and not self.ds[self.MyName]['Commons']['Flag']:
            logger.info(f'Flag is False in handleData() for {self.MyName}')
            
        if self.ds[self.MyName]['Commons']['TIMEOUT'] == 0 and self.ds[self.MyName]['Commons']['RELOAD_TIMEOUT'] != 0:
            logger.info(f'Message send resume: {self.MyName}')
            self.cfg['__mail__'].mailit(f"message from Datastore on {self.cfg['MyName']}", f'Message send resume: {self.MyName}')

        self.ds[self.MyName]['Commons']['Active'] = True
        self.ds[self.MyName]['Commons']['Counter'] += 1
        self.ds[self.MyName]['Commons']['TIMEOUT'] = self.ds[self.MyName]['Commons']['RELOAD_TIMEOUT']
        self.ds[self.MyName]['Commons']['lastUPD'] = str(datetime.datetime.now())
        
        self.ds['~DaBo']['updated DataSets']['CURRENT_DATA'] += 1
        
        for StoreShelf in DataSet:
            if StoreShelf == 'Commons':
                logger.warning(f"Commons can not be updated with handleData()")
                continue
            if StoreShelf not in self.ds[self.MyName]:
                logger.warning(f"DataSet: {StoreShelf} is not in Store: {self.MyName}")

        csv_line = timeStamp
                       
        Changed = False
        for StoreShelf in self.ds[self.MyName]:
            if StoreShelf == 'Commons' or StoreShelf == '__Service__':
                continue
            # complete incomplete DataSets with CURRENT_DATA
            if StoreShelf not in DataSet:
                DataSet[StoreShelf] = self.ds[self.MyName][StoreShelf]['CURRENT_DATA']

            changed = self.updateData(StoreShelf, DataSet.get(StoreShelf))
            if changed == None:
                continue
            self.ds['~DaBo']['updated Data']['CURRENT_DATA'] += 1
            Changed |= changed
            newVal = self.ds[self.MyName][StoreShelf]['CSV_MODE_DATA']
            try:
                x = self.ds[self.MyName][StoreShelf]['DECIMALS'] 
                if x != 0:
                    resstr = str(round(float(newVal), x))
                else:
                    resstr = str(int(newVal))
            except: 
                resstr = str(newVal)

            if self.ds[self.MyName]['Commons']['CSV_FORMAT'] == 'SINGLE' and changed:
                self.writeDataSet(StoreShelf, csv_line + ',' + resstr)
                continue
                
            if (self.ds[self.MyName]['Commons']['CSV_FORMAT'] == 'MULTI'):
                try:
                    resstr = str(round(self.ds[self.MyName][StoreShelf]['CSV_MODE_DATA'], x))
                except:
                    resstr = str(self.ds[self.MyName][StoreShelf]['CSV_MODE_DATA'])
                try:
                    self.ds[self.MyName]['Commons']['FILLED_UP']
                except Exception as e:
                    if not changed:
                        resstr = ''
                csv_line = csv_line + ',' + resstr
        if (self.ds[self.MyName]['Commons']['CSV_FORMAT'] == 'MULTI') and Changed:
            self.writeDataSet(StoreShelf, csv_line)
        try:
            if (self.ds[self.MyName]['Commons']['YML_FORMAT'] == 'CUMULATE'):
                mode = 'a'
            if (self.ds[self.MyName]['Commons']['YML_FORMAT'] == 'SINGLE'):
                mode = 'w'
            try:
                with open(f"{self.cfg['DataPath']}/{self.MyName}.yml", mode, encoding="utf-8") as file:
                    yaml.dump(DataSet, file, default_flow_style=False, allow_unicode=True)
            except Exception as err:
                logger.error(f"writing yml-file failed: {err}")
        except Exception as err:
            logger.error(f"Error in: {self.MyName} - {err}")
        self.DataBase()
        self.ds[self.MyName]['Commons']['Flag'] = False
        
    def updateData(self, DataShelf: str, DataBoxValue) -> bool:
        try:
            oldDataBoxValue = self.ds[self.MyName][DataShelf]['CURRENT_DATA']
            self.ds[self.MyName][DataShelf]['CURRENT_DATA'] = DataBoxValue
        except Exception as err:
            logger.error(f'{type(err).__name__} in: {self.MyName} - {DataShelf}')
            return None
        
        if self.MyName != '~DaBo': # dont count yourself
            self.ds['~DaBo']['last sender']['CURRENT_DATA'] = self.MyName
            self.ds['~DaBo']['Commons']['lastUPD'] = str(datetime.datetime.now())
            self.ds['~DaBo']['Commons']['Counter'] += 1
            
            if oldDataBoxValue != DataBoxValue:
                self.ds['~DaBo']['changed Data']['CURRENT_DATA'] += 1
            
        try: # values can be omitted in the *.signals.yml
            self.ds[self.MyName][DataShelf]['CURRENT_IN_RANGE'] = self.ds[self.MyName][DataShelf]['CURRENT_DATA'] >= \
                                                                self.ds[self.MyName][DataShelf]['MIN'] and \
                                                                self.ds[self.MyName][DataShelf]['CURRENT_DATA'] <= \
                                                                self.ds[self.MyName][DataShelf]['MAX']
            if (not self.ds[self.MyName][DataShelf]['CURRENT_IN_RANGE']):
                threading.Thread(target=self.ds[self.MyName][DataShelf]['__CaBa_1'], daemon=True).start() 
                self.ds[self.MyName]['Commons']['__CaBa_1']
                
        except: pass                                                                
        try:
            if(self.ds[self.MyName][DataShelf]['CSV_MODE'] == 'NONE'):
                return None
        except Exception:
            return None
        if(self.ds[self.MyName][DataShelf]['CSV_MODE'] == 'ALL'):
            self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] = DataBoxValue
            self.processValue(DataShelf, DataBoxValue)
            return True
        if(self.ds[self.MyName][DataShelf]['CSV_MODE'] == 'CHANGE'):
            if(self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] != DataBoxValue):
                self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] = DataBoxValue
                self.processValue(DataShelf, DataBoxValue)
                return True
            else: return False
        if(self.ds[self.MyName][DataShelf]['CSV_MODE'] == 'COUNT'):
            if(self.ds[self.MyName][DataShelf]['CNT']):
                self.ds[self.MyName][DataShelf]['CNT'] -= 1
                return False
            else:
                self.ds[self.MyName][DataShelf]['CNT'] = self.ds[self.MyName][DataShelf]['RELOAD_CNT'] - 1
                self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] = DataBoxValue
                self.processValue(DataShelf, DataBoxValue)
                return True
        if(self.ds[self.MyName][DataShelf]['CSV_MODE'] == 'AVR'):
            if self.ds[self.MyName][DataShelf]['CNT']:
                self.ds[self.MyName][DataShelf]['CNT'] -= 1
                self.ds[self.MyName][DataShelf]['AVR_SUBTOTAL'] += DataBoxValue
                return False           
            else:
                self.ds[self.MyName][DataShelf]['CNT'] = self.ds[self.MyName][DataShelf]['RELOAD_CNT'] - 1
                self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] = (self.ds[self.MyName][DataShelf]['AVR_SUBTOTAL'] + DataBoxValue) / \
                                                    self.ds[self.MyName][DataShelf]['RELOAD_CNT']
                self.ds[self.MyName][DataShelf]['AVR_SUBTOTAL'] = 0
                self.processValue(DataShelf, self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'])
                return True


    def processValue(self, DataShelf: str, value):
        self.ds[self.MyName][DataShelf]["lastUPD"] = str(datetime.datetime.now())
        try:
            self.ds[self.MyName][DataShelf]['CURRENT_IN_RANGE'] = self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] >= \
                                                                self.ds[self.MyName][DataShelf]['MIN'] and \
                                                                self.ds[self.MyName][DataShelf]['CSV_MODE_DATA'] <= \
                                                                self.ds[self.MyName][DataShelf]['MAX']
        except KeyError:
            pass

    def mergeOperation(self, data, str: str):
        if str[1] == 'and':
            data[self.MyName][str[-1][0]] = True
            for i in str[2:-1]:
                data[self.MyName][str[-1][0]] = data[self.MyName][str[-1][0]] and self.ds[i[0]][i[1]][i[2]]
        if str[1] == 'or':
            data[self.MyName][str[-1][0]] = False
            for i in str[2:-1]:
                data[self.MyName][str[-1][0]] = data[self.MyName][str[-1][0]] or self.ds[i[0]][i[1]][i[2]]
        if str[1] == 'add':
            data[self.MyName][str[-1][0]] = 0
            for i in str[2:-1]:
                data[self.MyName][str[-1][0]] += self.ds[i[0]][i[1]][i[2]]
        return data

    def _merge_thread(self, stop_event, sleep, index):
        mergeStr = self.ds[self.MyName]['Commons']['__MERGE__'][index]
        while not stop_event.is_set():
            data = dict()
            data[self.MyName] = dict()
            try:
                self.ds[self.MyName]['Commons']['TIMEOUT'] = self.ds[self.MyName]['Commons']['RELOAD_TIMEOUT']
                self.ds[self.MyName]['Commons']['Active'] = True
                if mergeStr[1] == 'get':
                    data[self.MyName][mergeStr[3][0]] = self.ds[mergeStr[2][0]][mergeStr[2][1]][mergeStr[2][2]]
                elif mergeStr[1] == 'cmpc':
                    data[self.MyName][mergeStr[3][0]] = str(self.ds[mergeStr[2][0]][mergeStr[2][1]][mergeStr[2][2]]) == str(mergeStr[4])
                elif mergeStr[1] == 'andc':
                    data[self.MyName][mergeStr[3][0]] = bool(self.ds[mergeStr[2][0]][mergeStr[2][1]][mergeStr[2][2]]) & mergeStr[4]
                elif mergeStr[1] == 'orc':
                    data[self.MyName][mergeStr[3][0]] = bool(self.ds[mergeStr[2][0]][mergeStr[2][1]][mergeStr[2][2]]) | mergeStr[4]
                elif mergeStr[1] == 'lut':
                    data[self.MyName][mergeStr[3]] = ''
                    for lota in mergeStr[5:]:
                        data[self.MyName][mergeStr[1]] += lota[1] + ' | '
                else: data = self.mergeOperation(data, mergeStr)
                self.handle_DataSet(data)
            except Exception as err:
                logging.error(f'merging error: {err}, in store {self.MyName}.')
                pass
            if stop_event.wait(sleep):
                break            
                  
    def DataBase(self):
        # print('DataBase: ', self.MyName)
        try:
            self.doRRD()
        except Exception as err:    
            logger.error(f'fehlr in RRD-Verarbeitung: {type(err).__name__} in: {err} {self.MyName}')

    def doRRD(self):
        try:
            DBInfo = self.ds[self.MyName]['Commons']['__RRD_DB__']
        except: 
            #logger.debug(f'no RRD-handling for: {self.MyName}')
            return
        for block in range(len(DBInfo)):
            rrdstr = 'N'
            for line in range(len(DBInfo[block])):
                res = self.getRRDValue(DBInfo[block][line])
                #logger.debug(f"---> {res}")
                if DBInfo[block][line][0] == 'OUTFILE':
                    rrdfile = f"{self.cfg['RRDPath']}/{str(res)}.rrd"
                else: rrdstr += ':' + str(res)
            logger.debug(f'calling rrdtool with: {rrdfile} {rrdstr}')
            cmd = [
                "rrdtool",
                "update",
                rrdfile,
                rrdstr
            ]
            err = subprocess.run(cmd, capture_output=True, text=True) 
            if err.returncode != 0:
                logger.warning(f'write RRD failed: {rrdfile} - {rrdstr} -> Error: {err}')
        return    

    def getRRDValue(self, DBStr: str):
        if DBStr[0][0] != '§':
            store = self.MyName
        else:
            store = DBStr[0][1:]

        if DBStr[1] == 'CONST':
            value = DBStr[2]
        elif DBStr[1][0] == '§':
            #logger.info(f"recursive RRD Command string in {store}. {DBStr[1][1:]}")
            value = self.cfg['__Dstore__'].ds[store][DBStr[1][1:]][DBStr[2]]
        else: logger.error(f"error in RRD Command string. {DBStr}")
        if DBStr[0] == 'INFILE':
            try:
                with open(f"{self.cfg['DataPath']}/{value}", 'r', encoding="utf-8") as file:
                    value = file.read()
            except:
                logger.warning(f"File not found: {self.cfg['DataPath']}{value}")
        # print('getRRDValue (store): ', store, ' - ', value)
        return str(value).split('.')[0]

    def writeDataSet(self, Shelf: str, line: str):
        timestamp_obj = datetime.datetime.fromisoformat(self.ds[self.MyName]['Commons']['initTime'])
        if (self.cfg['humanTimestamp']) or self.cfg['hirestime']:
            ext = 'log'
        else:
            ext = 'txt'
        if self.ds[self.MyName]['Commons']['CSV_FORMAT'] == 'SINGLE':
            FileName = f"{self.cfg['DataPath']}/{self.MyName}_{Shelf}_{self.ds[self.MyName][Shelf]['CSV_MODE']}{timestamp_obj.strftime(self.cfg['dataSuffix'])}.{ext}"
            self.ds[self.MyName]['Commons']['__header'] = f'time,{Shelf}'
        if self.ds[self.MyName]['Commons']['CSV_FORMAT'] == 'MULTI':
            FileName = f"{self.cfg['DataPath']}/{self.MyName}{timestamp_obj.strftime(self.cfg['dataSuffix'])}.{ext}"
        try:
            with open(FileName, 'r', encoding="utf-8") as DataFile: 
                pass
        except:        
            line = self.ds[self.MyName]['Commons']['__header'] + '\n' + line
        with open(FileName, 'a', encoding="utf-8") as DataFile: 
            DataFile.write(line + '\n')
            DataFile.close()

    def pick(self, Shelf, DataBox):
        if Shelf not in self.ds[self.MyName]:
            logger.error(f"unknown shelf '{Shelf}' in Store '{self.MyName}' to pick() data")
            return None, f"unknown shelf '{Shelf}' in Store '{self.MyName}' to pick() data"
        if DataBox not in self.ds[self.MyName][Shelf]:
            logger.error(f"unknown DataBox '{DataBox}' in Shelf '{Shelf}' of Store '{self.MyName}' to pick data")
            return None, f"unknown DataBox '{DataBox}' in Shelf '{Shelf}' of Store '{self.MyName}' to pick data"
        try:
            return not None, self.ds[self.MyName][Shelf][DataBox]
        except:
            logger.error(f"something went wrong in pick() for Store: {self.MyName}, Shelf: {Shelf}, DataBox: {DataBox}")
            return None, f"something went wrong in pick() for Store: {self.MyName}, Shelf: {Shelf}, DataBox: {DataBox}"

    def put(self, *args):
        if self.MyName not in self.ds:
            logger.error(f"unknown store: '{self.MyName}' to put() data")
            return None, f"unknown store: '{self.MyName}' to put() data"
        data = {self.MyName: {}}
        for Shelf in self.ds[self.MyName]:
            if Shelf != 'Commons':
                data[self.MyName][Shelf] = self.pick(self.MyName, Shelf, 'CURRENT_DATA')[1]
        for arg in args:
            if arg[0] not in self.ds[self.MyName]:
                return None, f"unknown shelf: '{arg[0]}' in store: '{self.MyName}' to put() data"
            data[self.MyName][arg[0]] = arg[1]
        Service.handle_DataSet(data)
        return not None, f"put data into store: '{self.MyName}'"

def whereis_store(store_group: dict, Store: str):
    for group in store_group.items():
        if Store in group[1].ds:
            return group[0]
    else:
        return None
