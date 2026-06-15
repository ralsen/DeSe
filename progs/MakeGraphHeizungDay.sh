rrdtool graph HeizungTempDay3.png \
  -t 'Heizung (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=Database3.rrd:temp0:AVERAGE \
  DEF:temp1=Database3.rrd:temp1:AVERAGE \
  DEF:temp2=Database3.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp1_av=temp1,AVERAGE \
  VDEF:temp1_ma=temp1,MAXIMUM \
  VDEF:temp1_mi=temp1,MINIMUM \
  VDEF:temp1_ak=temp1,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"              Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Ruecklauf " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:"%8.2lf\n" \
\
  LINE1:temp1#FF0000:"Vorlauf " \
  GPRINT:temp1_av:"   %8.2lf" \
  GPRINT:temp1_ma:"  %8.2lf" \
  GPRINT:temp1_mi:"%8.2lf" \
  GPRINT:temp1_ak:"%8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen " \
  GPRINT:temp2_av:"    %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:"%8.2lf\n" \

