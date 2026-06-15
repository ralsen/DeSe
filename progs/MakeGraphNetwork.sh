rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph $pngPath/Network.png  \
-t "Network Interface eth0" --vertical-label "Bytes/s" -s 'now - 1 month' -w 700 -h 200 \
DEF:chan0=$rrdPath/network.rrd:chan0:AVERAGE \
DEF:chan1=$rrdPath/network.rrd:chan1:AVERAGE \
CDEF:chan1n=chan1,-1,* \
VDEF:chan0a=chan0,AVERAGE \
VDEF:chan0m=chan0,MAXIMUM \
VDEF:chan0c=chan0,LAST \
VDEF:chan1a=chan1,AVERAGE \
VDEF:chan1m=chan1,MAXIMUM \
VDEF:chan1c=chan1,LAST \
COMMENT:"         Durchschnitt           Maximum          aktuell   pro Sekunde\n" \
AREA:chan0#00dd00:"Rx " \
GPRINT:chan0a:"%12.2lf %sb" \
GPRINT:chan0m:"%12.2lf %sb" \
GPRINT:chan0c:"%12.2lf %sb\n" \
AREA:chan1n#0000ff:"Tx " \
GPRINT:chan1a:"%12.2lf %sb" \
GPRINT:chan1m:"%12.2lf %sb" \
GPRINT:chan1c:"%12.2lf %sb"

