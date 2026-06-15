# 7 Tage - Load Average

rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph  $pngPath/LoadAvgWeek.png  \
-t "Load Average" --vertical-label "Average Load" -s 'now - 1 month' -e 'now' -w 700 -h 200 \
DEF:load1=$rrdPath/loadavg.rrd:load1:AVERAGE \
DEF:load5=$rrdPath/loadavg.rrd:load5:AVERAGE \
DEF:load15=$rrdPath/loadavg.rrd:load15:AVERAGE \
VDEF:load1l=load1,LAST \
VDEF:load5l=load5,LAST \
VDEF:load15l=load15,LAST \
AREA:load1#ff0000:"1 Minute,   letzter\:" GPRINT:load1l:"%5.2lf\n" \
AREA:load5#ff9900:"5 Minuten,  letzter\:" GPRINT:load5l:"%5.2lf     Grafik erzeugt am\n" \
AREA:load15#ffff00:"15 Minuten, letzter\:" GPRINT:load15l:"%5.2lf    $(/bin/date "+%d.%m.%Y %H\:%M\:%S")" \
LINE1:load5#ff9900:"" \
LINE1:load1#ff0000:""

