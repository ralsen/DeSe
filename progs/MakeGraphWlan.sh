rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

rrdtool graph $pngPath/wlan.png  \
-t "Network Interface wlan0" --vertical-label "Bytes/s" -s 'now - 1 month' -w 700 -h 200 \
DEF:eth0r=$rrdPath/wlan.rrd:eth0r:AVERAGE \
DEF:eth0t=$rrdPath/wlan.rrd:eth0t:AVERAGE \
CDEF:eth0tn=eth0t,-1,* \
VDEF:eth0ra=eth0r,AVERAGE \
VDEF:eth0rm=eth0r,MAXIMUM \
VDEF:eth0rc=eth0r,LAST \
VDEF:eth0ta=eth0t,AVERAGE \
VDEF:eth0tm=eth0t,MAXIMUM \
VDEF:eth0tc=eth0t,LAST \
COMMENT:"         Durchschnitt           Maximum          aktuell   pro Sekunde\n" \
AREA:eth0r#00dd00:"Rx " \
GPRINT:eth0ra:"%12.2lf %sb" \
GPRINT:eth0rm:"%12.2lf %sb" \
GPRINT:eth0rc:"%12.2lf %sb\n" \
AREA:eth0tn#0000ff:"Tx " \
GPRINT:eth0ta:"%12.2lf %sb" \
GPRINT:eth0tm:"%12.2lf %sb" \
GPRINT:eth0tc:"%12.2lf %sb"

