#!/bin/bash
rrdPath=$(pwd)/../rrd

AETH0=$(grep wlan0 /proc/net/dev)
AE0DOWN=$(echo $AETH0|tr \: \ |awk '{print $2}')
AE0UP=$(echo $AETH0|tr \: \ |awk '{print $10}')
rrdtool update $rrdPath/wlan.rrd N:$AE0DOWN:$AE0UP


