#!/bin/bash

# Verzeichnis mit den XML-Dateien
INPUT_DIR="./"  # Passe den Pfad an, falls die Dateien nicht im aktuellen Verzeichnis liegen

# Schleife über alle XML-Dateien im Verzeichnis
for xml_file in "$INPUT_DIR"/*.xml; do
    # Prüfen, ob Dateien gefunden wurden
    [ -e "$xml_file" ] || { echo "Keine XML-Dateien gefunden."; exit 1; }

    # RRD-Dateiname generieren (endet auf .rrx)
    rrd_file="${xml_file%.xml}.rrx"

    # Importieren der XML-Datei in RRD
    echo "Importiere $xml_file nach $rrd_file ..."
    rrdtool restore "$xml_file" "$rrd_file"
done

echo "Import abgeschlossen."
