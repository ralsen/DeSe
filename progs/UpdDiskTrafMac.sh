#!/bin/bash
rrdPath=$(pwd)/../rrd


# Ermitteln der Werte für disk0 (MB/s)
ASDA1IOR=$(iostat -d -n 1 1 2 | awk NR==3 | awk '{print $3}')
ASDA1IOW=$(iostat -d -n 1 1 2 | awk NR==3 | awk '{print $2}')
# Werte in RRDTool speichern
rrdtool update "$rrdPath/backuptraf.rrd" N:$ASDA1IOR:ASDA1IOW
echo $ASDA1IOR
echo $ASDA1IOW
