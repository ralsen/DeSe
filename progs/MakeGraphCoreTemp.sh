rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph $pngPath/CoreTemp.png \
 -t "Core Temperatur" --vertical-label "Grad Celsius" -s 'now - 1 year' -e now -w 700 -h 200 \
  DEF:core=$rrdPath/coretemp.rrd:core:AVERAGE \
\
  VDEF:core_ak=core,LAST \
  VDEF:core_av=core,AVERAGE \
  VDEF:core_mi=core,MINIMUM \
  VDEF:core_ma=core,MAXIMUM \
\
  COMMENT:"                       Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:core#ff0000:"Core" \
  GPRINT:core_av:" %8.2lf" \
  GPRINT:core_ma:" %8.2lf" \
  GPRINT:core_mi:" %8.2lf" \
  GPRINT:core_ak:" %8.2lf"

