datum=$(date +%Y_%m_%d)
echo $datum
# ./MakeGraphProcess.sh
./MakeGraphMemory.sh
./MakeGraphLoadAvg.sh
./MakeGraphNetwork.sh
# ./MakeGraphDisk.sh
./MakeGraphCoreTemp.sh
./MakeGraphsda.sh
cp -v ../png/*.png /var/www/html
# cp -v *.png /home/pi/samba/Daten/Projekte/Raspberry/Sensoren/BkUpServer

echo done
echo -----------------------

