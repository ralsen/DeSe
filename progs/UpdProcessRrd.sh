#!/bin/sh

# da sp�ter noch andere Scripte laufen, warten wir 15 Sekunden, bevor wir die Prozesse z�hlen
#sleep 15

# mit Hilfe von ps und wc die Anzahl der Prozesse ermitteln
rrdPath=$(pwd)/../rrd

PROZESSE=$(ps hax|wc -l)

# zum Schlu� kommen die Daten in die Datenbank
# N steht f�r das aktuelle Datum und Uhrzeit
rrdtool update $rrdPath/process.rrd N:$PROZESSE
