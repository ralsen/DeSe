#!/bin/bash
rrdPath=$(pwd)/../rrd

ASDA1=$(grep sda1 /proc/diskstats)
ASDA1READ=$(echo $ASDA1|tr \: \ |awk '{print $6}')
ASDA1WRITE=$(echo $ASDA1|tr \: \ |awk '{print $10}')
rrdtool update $rrdPath/backuptraf.rrd N:$ASDA1READ:$ASDA1WRITE


ASDA1=$(grep sdb1 /proc/diskstats)
ASDA1READ=$(echo $ASDA1|tr \: \ |awk '{print $6}')
ASDA1WRITE=$(echo $ASDA1|tr \: \ |awk '{print $10}')
rrdtool update $rrdPath/sambatraf.rrd N:$ASDA1READ:$ASDA1WRITE
