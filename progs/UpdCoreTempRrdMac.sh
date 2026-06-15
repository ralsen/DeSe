#!/bin/sh
rrdPath=$(pwd)/../rrd

#temp=$(vcgencmd measure_temp | sed "s/[^0-9.]//g")
temp=22.22
rrdtool update $rrdPath/coretemp.rrd N:$temp

