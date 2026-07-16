#!/bin/sh
# later rrdPath should be given as parameter
rrdPath=$(pwd)/rrd

LOAD=$(awk '{print $1":"$2":"$3}' < /proc/loadavg)
rrdtool update $rrdPath/loadavg.rrd N:$LOAD

