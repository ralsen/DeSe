#!/bin/bash

while true; do
    echo "=== $(date '+%Y-%m-%d %H:%M:%S') ==="

    FSWAP=`grep SwapFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
    FRAM=`grep MemFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`

    echo $FRAM
    echo $FSWAP
    sleep 5
done
FRAM=`grep MemFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
# freier Swap
FSWAP=`grep SwapFree: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
