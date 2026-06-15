rrdPath=$(pwd)/../rrd
pngPath=$(pwd)/../png

SWAPT=`grep SwapTotal: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`
MEMT=`grep MemTotal: /proc/meminfo|tr -s [:blank:]|cut -f2 -d" "`

MEMTOTAL=$(expr $MEMT \* 1024)
SWAPTOTAL=$(expr $SWAPT \* 1024)

# 7 Tage - RAM und Swap in einen
rrdtool graph $pngPath/MemoryWeek.png \
 -t "RAM und SWAP
" --vertical-label "Bytes" -s 'now - 1 month' -e 'now' -w 700 -h 200 \
DEF:fram=$rrdPath/memory.rrd:fram:AVERAGE \
DEF:fswap=$rrdPath/memory.rrd:fswap:AVERAGE \
CDEF:framb=fram,1024,* \
CDEF:fswapb=fswap,1024,* \
CDEF:bram=$MEMTOTAL,framb,- \
CDEF:bswap=$SWAPTOTAL,fswapb,- \
AREA:bram#99ffff:"belegter RAM" \
LINE1:framb#ff0000:"freier RAM" \
LINE1:bswap#000000:"belegter SWAP" \
LINE1:fswapb#006600:"freier SWAP"

