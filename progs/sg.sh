
echo "Jahreswerte:"
rrdtool graph SolarWattYear.png \
 -t "Solar" --vertical-label "Watt" -s 'now - 1 year' -e now -w 1400 -h 400 \
 DEF:watt=shellyplug-083A8DF437C7.rrd:verbrauch:AVERAGE \
 CDEF:smoothed=watt,10000,TREND \
 VDEF:watt_ak=watt,LAST \
 VDEF:watt_av=watt,AVERAGE \
 VDEF:watt_mi=watt,MINIMUM \
 VDEF:watt_ma=watt,MAXIMUM \
\
 PRINT:watt_ma:"Maximum      = %8.2lf W" \
 PRINT:watt_av:"Durchschnitt = %8.2lf W" \
\
 COMMENT:"                   Durchschnitt    Maximum\n" \
 LINE1:watt#0000ff:"Watt" \
 COMMENT:"   " \
 GPRINT:watt_av:"%8.2lf" \
 COMMENT:"" \
 GPRINT:watt_ma:"%8.2lf" \
#\
# LINE2:smoothed#0000ff:"Watt geglaettet" \
# AREA:smoothed#0000ff:

watt=" W"

echo
echo "Monatswerte:"
rrdtool graph SolarWattMonth.png \
 -t "Solar" --vertical-label "Watt" -s 'now - 1 month' -e now -w 1400 -h 400 \
 DEF:watt=shellyplug-083A8DF437C7.rrd:verbrauch:AVERAGE \
 CDEF:smoothed=watt,10000,TREND \
 VDEF:watt_ak=watt,LAST \
 VDEF:watt_av=watt,AVERAGE \
 VDEF:watt_mi=watt,MINIMUM \
 VDEF:watt_ma=watt,MAXIMUM \
\
 PRINT:watt_ma:"Maximum      = %8.2lf W" \
 PRINT:watt_av:"Durchschnitt = %8.2lf W" \
\
 COMMENT:"                   Durchschnitt    Maximum\n" \
 LINE1:watt#0000ff:"Watt" \
 COMMENT:"   " \
 GPRINT:watt_av:"%8.2lf" \
 COMMENT:"" \
 GPRINT:watt_ma:"%8.2lf" \
#\
# LINE2:smoothed#0000ff:"Watt geglaettet" \
# AREA:smoothed#0000ff:

watt=" W"

echo
echo "Wochenwerte:"
rrdtool graph SolarWattWeek.png \
 -t "Solar" --vertical-label "Watt" -s 'now - 7 day' -e now -w 1400 -h 400 \
 DEF:watt=shellyplug-083A8DF437C7.rrd:verbrauch:AVERAGE \
 CDEF:smoothed=watt,10000,TREND \
 VDEF:watt_ak=watt,LAST \
 VDEF:watt_av=watt,AVERAGE \
 VDEF:watt_mi=watt,MINIMUM \
 VDEF:watt_ma=watt,MAXIMUM \
\
 PRINT:watt_ma:"Maximum      = %8.2lf W" \
 PRINT:watt_av:"Durchschnitt = %8.2lf W" \
\
 COMMENT:"                   Durchschnitt    Maximum\n" \
 LINE1:watt#0000ff:"Watt" \
 COMMENT:"   " \
 GPRINT:watt_av:"%8.2lf" \
 COMMENT:"" \
 GPRINT:watt_ma:"%8.2lf" \
#\
# LINE2:smoothed#0000ff:"Watt geglaettet" \
# AREA:smoothed#0000ff:

watt=" W"

echo
echo "Tageswerte:"
rrdtool graph SolarWattDay.png \
 -t "Solar" --vertical-label "Watt" -s 'now - 1 day' -e now -w 1400 -h 400 \
 DEF:watt=shellyplug-083A8DF437C7.rrd:verbrauch:AVERAGE \
 CDEF:smoothed=watt,10000,TREND \
 VDEF:watt_ak=watt,LAST \
 VDEF:watt_av=watt,AVERAGE \
 VDEF:watt_mi=watt,MINIMUM \
 VDEF:watt_ma=watt,MAXIMUM \
\
 PRINT:watt_ma:"Maximum      = %8.2lf W" \
 PRINT:watt_av:"Durchschnitt = %8.2lf W" \
\
 COMMENT:"                   Durchschnitt    Maximum\n" \
 LINE1:watt#0000ff:"Watt" \
 COMMENT:"   " \
 GPRINT:watt_av:"%8.2lf" \
 COMMENT:"" \
 GPRINT:watt_ma:"%8.2lf" \
#\
# LINE2:smoothed#0000ff:"Watt geglaettet" \
# AREA:smoothed#0000ff:

watt=" W"
echo
last_value=$(rrdtool lastupdate shellyplug-083A8DF437C7.rrd | tail -n 1 | awk '{print $2}')
printf "Aktuell      = %8.2lf W\n" "${last_value}"

