#!/bin/bash

# Verzeichnis mit den RRD-Dateien
INPUT_DIR="./"  # Passe den Pfad an, falls die Dateien nicht im aktuellen Verzeichnis liegen

# Schleife über alle RRD-Dateien im Verzeichnis
for rrd_file in "$INPUT_DIR"/*.rrd; do
    # Prüfen, ob Dateien gefunden wurden
    [ -e "$rrd_file" ] || { echo "Keine RRD-Dateien gefunden."; exit 1; }

    # XML-Dateiname generieren
    xml_file="${rrd_file%.rrd}.xml"

    # Exportieren der RRD-Datei in XML
    echo "Exportiere $rrd_file nach $xml_file ..."
    rrdtool dump "$rrd_file" "$xml_file"
done

echo "Export abgeschlossen."
