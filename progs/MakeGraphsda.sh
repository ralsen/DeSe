rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph $pngPath/sambatraf.png \
-t "samba-Transfer" --vertical-label "Sectors/s" -s 'now - 1 month' -e 'now' -w 700 -h 200 \
DEF:chan1=$rrdPath/sambatraf.rrd:chan1:AVERAGE \
DEF:chan0=$rrdPath/sambatraf.rrd:chan0:AVERAGE \
CDEF:chan0n=chan0,-1,* \
VDEF:chan1a=chan1,AVERAGE \
VDEF:chan1m=chan1,MAXIMUM \
VDEF:chan1c=chan1,LAST \
VDEF:chan0a=chan0,AVERAGE \
VDEF:chan0m=chan0,MAXIMUM \
VDEF:chan0c=chan0,LAST \
COMMENT:"         Durchschnitt           Maximum          aktuell   (pro Sekunde)\n" \
AREA:chan1#00dd00:"Read  " \
GPRINT:chan1a:"%8.2lf %sb" \
GPRINT:chan1m:"%8.2lf %sb" \
GPRINT:chan1c:"%8.2lf %sb\n" \
AREA:chan0n#0000ff:"Write " \
GPRINT:chan0a:"%8.2lf %sb" \
GPRINT:chan0m:"%8.2lf %sb" \
GPRINT:chan0c:"%8.2lf %sb"

rrdtool graph $pngPath/backuptraf.png \
-t "backup-Transfer" --vertical-label "Sectors/s" -s 'now - 1 month' -e 'now' -w 700 -h 200 \
DEF:chan1=$rrdPath/backuptraf.rrd:chan1:AVERAGE \
DEF:chan0=$rrdPath/backuptraf.rrd:chan0:AVERAGE \
CDEF:chan0n=chan0,-1,* \
VDEF:chan1a=chan1,AVERAGE \
VDEF:chan1m=chan1,MAXIMUM \
VDEF:chan1c=chan1,LAST \
VDEF:chan0a=chan0,AVERAGE \
VDEF:chan0m=chan0,MAXIMUM \
VDEF:chan0c=chan0,LAST \
COMMENT:"         Durchschnitt           Maximum          aktuell   (pro Sekunde)\n" \
AREA:chan1#00dd00:"Read  " \
GPRINT:chan1a:"%8.2lf %sb" \
GPRINT:chan1m:"%8.2lf %sb" \
GPRINT:chan1c:"%8.2lf %sb\n" \
AREA:chan0n#0000ff:"Write " \
GPRINT:chan0a:"%8.2lf %sb" \
GPRINT:chan0m:"%8.2lf %sb" \
GPRINT:chan0c:"%8.2lf %sb"

