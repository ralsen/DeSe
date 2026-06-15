import os
import sys
import threading
import logging 
import io
import sys
import config as cfg
import json

logger = logging.getLogger(__name__)

def drawImages(dicts):
    """
    The function `drawImages` takes a list of dictionaries as input and iterates over each dictionary to
    call the `drawImage` function with the values of the 'box', 'dev', and '1_w' keys as arguments.
    
    :param dicts: A list of dictionaries. Each dictionary contains two keys: 'dev' and 'box'
    """
    #logger.debug(f'drawImages')

    for dic in dicts:
        #print(f"{dic['dev']} - {dic['box']}")
        drawImage(dic['box'], dic['dev'], '1_w')

def drawImage(diagram, dev, period):
    """
    The `drawImage` function generates an image file based on a given diagram, device, and period using
    RRDTool.
    
    :param diagram: The "diagram" parameter represents the name of the diagram or chart that you want to
    draw
    :param dev: The `dev` parameter represents the device for which the image is being drawn. It is used
    to construct the file paths and to replace placeholders in the `rrdcmd` string
    :param period: The `period` parameter is a string that represents the time period for which the
    image is being drawn. It is used to generate the filename and to replace the `{period}` placeholder
    in the `rrdcmd` string. The underscores in the `period` string are replaced with spaces before being
    used
    """
    #print('drawImage()')
    pngfile = f"{cfg.ini['PNGPath']}/{diagram}_{dev}_{period}.png"
    rrdfile = f"{cfg.ini['RRDPath']}/{diagram}_{dev}.rrd"
    rrdcmd = cfg.ini['rrdstr'].replace('{pngfile}', pngfile)
    rrdcmd = rrdcmd.replace('{rrdfile}', rrdfile)
    rrdcmd = rrdcmd.replace('{header}', dev)
    rrdcmd = rrdcmd.replace('{chx}', diagram)
    space = ' ' * (16 - len(diagram))
    rrdcmd = rrdcmd.replace('{space}', space)
    for entry in cfg.ini['dias'][dev[:-12]]:
        if diagram in entry:
            rrdcmd = rrdcmd.replace('{unit}', entry[1])
    rrdcmd = rrdcmd.replace('{period}', period.replace('_', ' '))
    if err := os.system(rrdcmd):
        logger.debug(f"calling: {rrdcmd}")
        logger.info(f"rrd return: {err}")

if __name__ == '__main__':
    current_file_path = os.path.realpath(__file__)
    current_file_name = os.path.basename(current_file_path)

    cfg.init(current_file_name)
    logger.info(f'---------- starting {current_file_name} ----------') 

    para = str(sys.argv[1:])
    para = para[1:-1]
    para = para.replace(':', '": "')
    para = para.replace('{', '{"')
    para = para.replace(',', '","')
    para = para.replace('}', '"}')
    para = para.replace('}","{', '},{')
    jstr = f"{para}"
    dicts = json.loads(jstr[1:-1])
    drawImages(dicts)