rrdtool graph /home/dabo/dabo/png/CPU_load_all.png \
  -t 'Leistung (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:ch0=/home/dabo/dabo/rrd/CPU_load_primary00305914880b.rrd:ch0:AVERAGE \
  DEF:ch1=/home/dabo/dabo/rrd/CPU_load_primary0030591540e0.rrd:ch0:AVERAGE \
  DEF:ch2=/home/dabo/dabo/rrd/CPU_load_primary4c52629f697c.rrd:ch0:AVERAGE \
  DEF:ch3=/home/dabo/dabo/rrd/CPU_load_secondary000e8e93adb2.rrd:ch0:AVERAGE \
  DEF:ch4=/home/dabo/dabo/rrd/CPU_load_secondary000e8eaa31d1.rrd:ch0:AVERAGE \
  DEF:ch5=/home/dabo/dabo/rrd/CPU_load_secondary000e8eaa31d6.rrd:ch0:AVERAGE \
\
  VDEF:ch0_av=ch0,AVERAGE \
  VDEF:ch0_ma=ch0,MAXIMUM \
  VDEF:ch0_mi=ch0,MINIMUM \
  VDEF:ch0_ak=ch0,LAST \
\
  VDEF:ch1_av=ch1,AVERAGE \
  VDEF:ch1_ma=ch1,MAXIMUM \
  VDEF:ch1_mi=ch1,MINIMUM \
  VDEF:ch1_ak=ch1,LAST \
\
  VDEF:ch2_av=ch2,AVERAGE \
  VDEF:ch2_ma=ch2,MAXIMUM \
  VDEF:ch2_mi=ch2,MINIMUM \
  VDEF:ch2_ak=ch2,LAST \
\
  VDEF:ch3_av=ch3,AVERAGE \
  VDEF:ch3_ma=ch3,MAXIMUM \
  VDEF:ch3_mi=ch3,MINIMUM \
  VDEF:ch3_ak=ch3,LAST \
\
  VDEF:ch4_av=ch4,AVERAGE \
  VDEF:ch4_ma=ch4,MAXIMUM \
  VDEF:ch4_mi=ch4,MINIMUM \
  VDEF:ch4_ak=ch4,LAST \
\
  VDEF:ch5_av=ch5,AVERAGE \
  VDEF:ch5_ma=ch5,MAXIMUM \
  VDEF:ch5_mi=ch5,MINIMUM \
  VDEF:ch5_ak=ch5,LAST \
\
  COMMENT:"                               Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:ch0#00FF00:"Load primary00305914880b  " \
  GPRINT:ch0_av:" %8.2lf" \
  GPRINT:ch0_ma:"  %8.2lf" \
  GPRINT:ch0_mi:"%8.2lf" \
  GPRINT:ch0_ak:"%8.2lf\n" \
\
  LINE1:ch1#0000FF:"Load primary0030591540e0  " \
  GPRINT:ch1_av:" %8.2lf" \
  GPRINT:ch1_ma:"  %8.2lf" \
  GPRINT:ch1_mi:"%8.2lf" \
  GPRINT:ch1_ak:"%8.2lf\n" \
\
  LINE1:ch2#FF0000:"Load primary4c52629f697c  " \
  GPRINT:ch2_av:" %8.2lf" \
  GPRINT:ch2_ma:"  %8.2lf" \
  GPRINT:ch2_mi:"%8.2lf" \
  GPRINT:ch2_ak:"%8.2lf\n" \
\
  LINE1:ch3#007F00:"Load secondary000e8e93adb2" \
  GPRINT:ch3_av:" %8.2lf" \
  GPRINT:ch3_ma:"  %8.2lf" \
  GPRINT:ch3_mi:"%8.2lf" \
  GPRINT:ch3_ak:"%8.2lf\n" \
\
  LINE1:ch4#00007F:"Load secondary000e8eaa31d1" \
  GPRINT:ch4_av:" %8.2lf" \
  GPRINT:ch4_ma:"  %8.2lf" \
  GPRINT:ch4_mi:"%8.2lf" \
  GPRINT:ch4_ak:"%8.2lf\n" \
\
  LINE1:ch5#7F0000:"Load secondary000e8eaa31d6" \
  GPRINT:ch5_av:" %8.2lf" \
  GPRINT:ch5_ma:"  %8.2lf" \
  GPRINT:ch5_mi:"%8.2lf" \
  GPRINT:ch5_ak:"%8.2lf\n" \
\

