pa=/mnt/samba/Daten/Projekte/Projects/DaBo64/progs
gr=@better.png
rrd=~eth0.rrd

rrdtool graph $pa/../png/$gr \
  -t "eth0 (4 Stunden)" \
  --vertical-label "bytes/s" \
  -s "now - 1 week" \
  -e "now" \
  -w 1000 -h 300 \
  --full-size-mode \
  --border 0 \
  --color BACK#FFFFFF \
  --color CANVAS#FFFFFF \
  --color GRID#DDDDDD \
  --color MGRID#BBBBBB \
  --color AXIS#666666 \
  --color FONT#000000 \
  --grid-dash 1:3 \
  --font TITLE:12:Arial \
  --font AXIS:10:Arial \
  --font LEGEND:9:Arial \
  COMMENT:"                    Durchschnitt   Maximum   Minimum    aktuell\n" \
  DEF:ds0=$pa/../rrd/$rrd:ds0:AVERAGE \
  CDEF:chan0n=ds0,-1,* \
  VDEF:ds0_av=ds0,AVERAGE \
  VDEF:ds0_ma=ds0,MAXIMUM \
  VDEF:ds0_mi=ds0,MINIMUM \
  VDEF:ds0_ak=ds0,LAST \
  DEF:ds1=$pa/../rrd/$rrd:ds1:AVERAGE \
  VDEF:ds1_av=ds1,AVERAGE \
  VDEF:ds1_ma=ds1,MAXIMUM \
  VDEF:ds1_mi=ds1,MINIMUM \
  VDEF:ds1_ak=ds1,LAST \
  LINE2:chan0n#FF5500CC:"  Tx  " \
  GPRINT:ds0_av:" %8.2lf" \
  GPRINT:ds0_ma:" %8.2lf" \
  GPRINT:ds0_mi:" %8.2lf" \
  GPRINT:ds0_ak:" %8.2lf" \
  COMMENT:"\n" \
  LINE2:ds1#00AAFFCC:"  Rx  " \
  GPRINT:ds1_av:" %8.2lf" \
  GPRINT:ds1_ma:" %8.2lf" \
  GPRINT:ds1_mi:" %8.2lf" \
  GPRINT:ds1_ak:" %8.2lf" \
  COMMENT:"\n"

