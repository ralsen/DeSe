#!/bin/sh
rrdPath=$(pwd)/../rrd

temp=$(vcgencmd measure_temp | sed "s/[^0-9.]//g")
rrdtool update $rrdPath/coretemp.rrd N:$temp

