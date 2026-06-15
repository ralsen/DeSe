#!/bin/bash
# 36 Stunden - Prozesse
rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph $pngPath/Process3Day.png \
--start -129600 -a PNG --vertical-label "Prozesse" -w 600 -h 100 \
DEF:auswertung=$rrdPath/process.rrd:processes:AVERAGE \
LINE1:auswertung#ff0000:"Anzahl Prozesse" \
VDEF:auswertung1=auswertung,AVERAGE \
GPRINT:auswertung1:"Durchschnitt Anzahl Prozesse\: %lg" \
DEF:maxaus=process.rrd:processes:MAX \
VDEF:maxaus1=maxaus,MAXIMUM \
GPRINT:maxaus1:"Max Anzahl Prozesse\: %lg\j"

# 7 Tage - Prozesse
rrdtool graph $pngPath/ProcessWeek.png \
--start -604800 -a PNG --vertical-label "Prozesse" -w 600 -h 100 \
DEF:auswertung=$rrdPath/process.rrd:processes:AVERAGE \
LINE1:auswertung#ff0000:"Anzahl Prozesse" \
VDEF:auswertung1=auswertung,AVERAGE \
GPRINT:auswertung1:"Durchschnitt Anzahl Prozesse\: %lg" \
DEF:maxaus=process.rrd:processes:MAX \
VDEF:maxaus1=maxaus,MAXIMUM \
GPRINT:maxaus1:"Max Anzahl Prozesse\: %lg\j"
