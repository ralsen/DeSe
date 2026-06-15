
datum=$(date +%Y_%m_%d)
echo $datum>/dev/null 2>&1
# ./MakeGraphProcess.sh
./MakeGraphMemory.sh>/dev/null 2>&1
./MakeGraphLoadAvg.sh>/dev/null 2>&1
./MakeGraphNetwork.sh>/dev/null 2>&1
# ./MakeGraphDisk.sh
./MakeGraphCoreTemp.sh>/dev/null 2>&1
./MakeGraphsda.sh>/dev/null 2>&1
cp -v ../png/*.png /var/www/html>/dev/null 2>&1
# cp -v *.png /home/pi/samba/Daten/Projekte/Raspberry/Sensoren/BkUpServer

echo done>/dev/null 2>&1
echo ----------------------->/dev/null 2>&1

