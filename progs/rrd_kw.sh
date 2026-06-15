rrdtool graph /home/dabo/dabo/png/kw_primary4c52629f697c.png \
  -t 'Leistung (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 1050 -h 300 \
  DEF:ch0=/home/dabo/dabo/rrd/kw_primary4c52629f697c.rrd:ch0:AVERAGE \
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

