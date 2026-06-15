#!/bin/bash

# die Daten rund um RAM und SWAP kommen aus /proc/meminfo
# freier RAM
rrdPath=$(pwd)/../rrd

FRAM=`grep MemFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
# freier Swap
FSWAP=`grep SwapFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`

# rein damit in die RRD
rrdtool update $rrdPath/memory.rrd N:$FRAM:$FSWAP

