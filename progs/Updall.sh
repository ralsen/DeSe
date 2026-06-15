#!/bin/sh

prgPath=$(pwd)

$prgPath/UpdMemoryRrd.sh
$prgPath/UpdLoadAvgRrd.sh
$prgPath/UpdNetworkRrd.sh
$prgPath/UpdWlan.sh
$prgPath/UpdCoreTempRrd.sh
$prgPath/UpdDiskTraf.sh
#$prgPath/all.sh
