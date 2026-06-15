rrdtool graph /home/dabo/dabo/png/CPU_load_secondary000e8eaa31d1.png \
  -t 'Leistung (Tag)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:ch0=/home/dabo/dabo/rrd/CPU_load_secondary000e8eaa31d1.rrd:ch0:AVERAGE \
\
  VDEF:ch0_av=ch0,AVERAGE \
  VDEF:ch0_ma=ch0,MAXIMUM \
  VDEF:ch0_mi=ch0,MINIMUM \
  VDEF:ch0_ak=ch0,LAST \
\
  COMMENT:"              Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:ch0#00FF00:"kW       " \
  GPRINT:ch0_av:" %8.2lf" \
  GPRINT:ch0_ma:"  %8.2lf" \
  GPRINT:ch0_mi:"%8.2lf" \
  GPRINT:ch0_ak:"%8.2lf\n" \

