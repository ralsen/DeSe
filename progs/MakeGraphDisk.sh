# sda1
rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph $pngPath/sda1.png  -b 1024 --start -129600 \
-t "Belegung sda1 (EXT2)" --vertical-label "Bytes belegt" -w 600 -h 100 \
DEF:sda1=$rrdPath/disksda1.rrd:sda1:AVERAGE AREA:sda1#00ff00:"belegter Platz"
rrdtool graph $pngPath/sda1-7.png -b 1024 --start -604800 \
-t "Belegung sda1 (EXT2)" --vertical-label "Bytes belegt" -w 600 -h 100 \
DEF:sda1=$rrdPath/disksda1.rrd:sda1:AVERAGE AREA:sda1#00ff00:"belegter Platz"


