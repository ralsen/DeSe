#!/bin/bash

PROC_NAME="MakeGraphics V1.0"

PROC_DIR="progs"
RRD_DIR="rrd"
PNG_DIR="png"
LOG_FILE="procs.lox"

#RRD_PATH="/home/pi/samba/Daten/Projekte/Raspberry/${PROC_DIR}"
#LOG_PATH="/home/pi/samba/Daten/Projekte/Raspberry/${PROC_DIR}/log"


PROC_PATH="/mnt/samba/Daten/Projekte/Projects/DaBo64/${PROC_DIR}"
RRD_PATH="/mnt/samba/Daten/Projekte/Projects/DaBo64/${RRD_DIR}"
PNG_PATH="/mnt/samba/Daten/Projekte/Projects/DaBo64/${PNG_DIR}"
LOG_PATH="/mnt/samba/Daten/Projekte/Projects/DaBo64/${PROC_DIR}/log"

PROC_LOG="${LOG_PATH}/${LOG_FILE}"

datum=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
datumInfo="${datum} [INFO   ] - "

echo "----------------------">>$PROC_LOG
echo -n $datumInfo >>$PROC_LOG
echo " ${PROC_NAME} started">>$PROC_LOG

echo "----------------------"
echo -n $datumInfo
echo " ${PROC_NAME} started"  

rrdtool graph $PNG_PATH/WintergartenTempHour.png \
  -t 'Wintergarten (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Wintergarten " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \


rrdtool graph $PNG_PATH/WintergartenTempDay.png \
  -t 'Wintergarten (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Wintergarten " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/WintergartenTempWeek.png \
  -t 'Wintergarten (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Wintergarten " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/WintergartenTempMonth.png \
  -t 'Wintergarten (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Wintergarten " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/WintergartenTempYear.png \
  -t 'Wintergarten (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Wintergarten " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/WintergartenTemp3Year.png \
  -t 'Wintergarten (3 Jahre)' --vertical-label "Grad Celsius" -s 'now - 3 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Wintergarten-4091514EB45D.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Wintergarten " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

# --------------------------------

rrdtool graph $PNG_PATH/HeizungTempHour.png \
  -t 'Heizung (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#FF0000:"Vorlauf       " \
  GPRINT:temp0_av:"    %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#00FF00:"Ruecklauf    " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen       " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \


rrdtool graph $RRD_PATH/HeizungTempDay.png \
  -t 'Heizung (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#FF0000:"Vorlauf      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#00FF00:"Ruecklauf    " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#808080:"Abgas        " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \
\

rrdtool graph $PNG_PATH/HeizungTempWeek.png \
  -t 'Heizung (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#FF0000:"Vorlauf      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#00FF00:"Ruecklauf    " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#808080:"Abgas        " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \
\

rrdtool graph $PNG_PATH/HeizungTempMonth.png \
  -t 'Heizung (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#FF0000:"Vorlauf      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#00FF00:"Ruecklauf    " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#808080:"Abgas        " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \

rrdtool graph $PNG_PATH/HeizungTempYear.png \
  -t 'Heizung (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Heizung-CC50E33BF64D.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#FF0000:"Vorlauf      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#00FF00:"Ruecklauf    " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#808080:"Abgas        " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \
\

# --------------------------------

rrdtool graph $PNG_PATH/BueroTempHour.png \
  -t 'Buero (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Buero-68C63A87FACE.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Buero-68C63A87FACE.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Buero-68C63A87FACE.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Fenster      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#0000FF:"Schreibtisch " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen       " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \


rrdtool graph $PNG_PATH/BueroTempDay.png \
  -t 'Buero (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Buero-68C63A87FACE.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Buero-68C63A87FACE.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Buero-68C63A87FACE.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Fenster      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#0000FF:"Schreibtisch " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen       " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \

rrdtool graph $PNG_PATH/BueroTempWeek.png \
  -t 'Buero (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Buero-68C63A87FACE.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Buero-68C63A87FACE.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Buero-68C63A87FACE.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Fenster      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#0000FF:"Schreibtisch " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen       " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \

rrdtool graph $PNG_PATH/BueroTempMonth.png \
  -t 'Buero (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Buero-68C63A87FACE.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Buero-68C63A87FACE.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Buero-68C63A87FACE.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Fenster      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#0000FF:"Schreibtisch " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen       " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \

rrdtool graph $PNG_PATH/BueroTempYear.png \
  -t 'Buero (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Buero-68C63A87FACE.rrd:temp0:AVERAGE \
  DEF:temp1=$RRD_PATH/Buero-68C63A87FACE.rrd:temp1:AVERAGE \
  DEF:temp2=$RRD_PATH/Buero-68C63A87FACE.rrd:temp2:AVERAGE \
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
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Fenster      " \
  GPRINT:temp0_av:"     %5.2lf" \
  GPRINT:temp0_ma:"     %5.2lf" \
  GPRINT:temp0_mi:"  %5.2lf" \
  GPRINT:temp0_ak:"    %5.2lf\n" \
\
  LINE1:temp1#0000FF:"Schreibtisch " \
  GPRINT:temp1_av:"     %5.2lf" \
  GPRINT:temp1_ma:"     %5.2lf" \
  GPRINT:temp1_mi:"  %5.2lf" \
  GPRINT:temp1_ak:"    %5.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen       " \
  GPRINT:temp2_av:"     %5.2lf" \
  GPRINT:temp2_ma:"     %5.2lf" \
  GPRINT:temp2_mi:"  %5.2lf" \
  GPRINT:temp2_ak:"    %5.2lf\n" \

# ------------------------------------------------------------------------------

rrdtool graph $PNG_PATH/SchlafzimmerTempHour.png \
  -t 'Schlafzimmer (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Schlafzimmer " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \


rrdtool graph $PNG_PATH/SchlafzimmerTempDay.png \
  -t 'Schlafzimmer (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Schlafzimmer " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/SchlafzimmerTempWeek.png \
  -t 'Schlafzimmer (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Schlafzimmer " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/SchlafzimmerTempMonth.png \
  -t 'Schlafzimmer (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Schlafzimmer " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/SchlafzimmerTempYear.png \
  -t 'Schlafzimmer (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Schlafzimmer-DC4F2210C60E.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Schlafzimmer " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

# ------------------------------------------------------------------------------

rrdtool graph $PNG_PATH/JanTempHour.png \
  -t 'Jan (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Jan          " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \


rrdtool graph $PNG_PATH/JanTempDay.png \
  -t 'Jan (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Jan          " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/JanTempWeek.png \
  -t 'Jan (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Jan          " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/JanTempMonth.png \
  -t 'Jan (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Jan          " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/JanTempYear.png \
  -t 'Jan (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Jan-CC50E35DA7A5.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Jan          " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

# --------------------------------

rrdtool graph $PNG_PATH/Lars_ZTempHour.png \
  -t 'Lars Zimmer (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_Z       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \


rrdtool graph $PNG_PATH/Lars_ZTempDay.png \
  -t 'Lars Zimmer (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_Z       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/Lars_ZTempWeek.png \
  -t 'Lars Zimmer (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_Z       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/Lars_ZTempMonth.png \
  -t 'Lars Zimmer (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_Z       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/Lars_ZTempYear.png \
  -t 'Lars Zimmer (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Zimmer-CC50E35DA8F3.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_Z       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

# ------------------------------------------------------------------------------

rrdtool graph $PNG_PATH/Lars_DTempHour.png \
  -t 'Lars Dachboden (Stunde)' --vertical-label "Grad Celsius" -s 'now - 4 hour' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_D       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \


rrdtool graph $PNG_PATH/Lars_DTempDay.png \
  -t 'Lar Dachboden (Tag)' --vertical-label "Grad Celsius" -s 'now - 1 day' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_D       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/Lars_DTempWeek.png \
  -t 'Lars Dachboden (Woche)' --vertical-label "Grad Celsius" -s 'now - 1 week' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_D       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/Lars_DTempMonth.png \
  -t 'Lars Dachboden (Monat)' --vertical-label "Grad Celsius" -s 'now - 1 month' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_D       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \

rrdtool graph $PNG_PATH/Lars_DTempYear.png \
  -t 'Lars Dachboden (Jahr)' --vertical-label "Grad Celsius" -s 'now - 1 year' -e 'now'  -w 700 -h 200 \
  DEF:temp0=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp0:AVERAGE \
  DEF:temp2=$RRD_PATH/Lars-Dach-CC50E33C0671.rrd:temp2:AVERAGE \
\
  VDEF:temp0_av=temp0,AVERAGE \
  VDEF:temp0_ma=temp0,MAXIMUM \
  VDEF:temp0_mi=temp0,MINIMUM \
  VDEF:temp0_ak=temp0,LAST \
\
  VDEF:temp2_av=temp2,AVERAGE \
  VDEF:temp2_ma=temp2,MAXIMUM \
  VDEF:temp2_mi=temp2,MINIMUM \
  VDEF:temp2_ak=temp2,LAST \
\
  COMMENT:"                  Durchschnitt   Maximum   Minimum    aktuell\n" \
  LINE1:temp0#00FF00:"Lars_D       " \
  GPRINT:temp0_av:" %8.2lf" \
  GPRINT:temp0_ma:"  %8.2lf" \
  GPRINT:temp0_mi:"%8.2lf" \
  GPRINT:temp0_ak:" %8.2lf\n" \
\
  LINE1:temp2#FFA500:"Aussen   " \
  GPRINT:temp2_av:"     %8.2lf" \
  GPRINT:temp2_ma:"  %8.2lf" \
  GPRINT:temp2_mi:"%8.2lf" \
  GPRINT:temp2_ak:" %8.2lf\n" \


# ------------------------------------------------------------------------------
datum=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
datumInfo="${datum} [INFO   ] - "
 
echo -n $datumInfo >>$PROC_LOG
echo  " ${PROC_NAME} sending all to Dropbox">>$PROC_LOG

echo -n $datumInfo
echo  " ${PROC_NAME} sending all to Dropbox" 

cp -v $PNG_PATH/*.png /var/www/html

datum=$(date "+%Y-%m-%d_%H-%M-%S-%3N")
datumInfo="${datum} [INFO   ] - "
 
echo -n $datumInfo >>$PROC_LOG
echo  " ${PROC_NAME} stopped">>$PROC_LOG

echo -n $datumInfo
echo  " ${PROC_NAME} stopped" 
