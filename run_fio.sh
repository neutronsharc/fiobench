#!/bin/bash

numjobs_num=$1
DEST=$2

runtime=30
fio=`which fio`

#todo support 512 bytes

#BSSIZE="4k"
#qdepth="1"
#qdepth="1 2 4 8 16 32 64 128 256 512"

BSSIZE="4k 8k 16k"
RW_BSSIZE="4k,4k 4k,128k 4k,200k 4k,256k 4k,1M"
qdepth="4"
fsize="1G"
mixread="99"

for iodepth in $qdepth; do

for BS in $RW_BSSIZE; do
    echo; echo "==================================="
    echo "fio randrw rwmixread=${mixread} iodepth=$iodepth, bs=$BS"
    echo "------------------"
    $fio -directory=/${DEST}/fiotest/ -filename_format=fiotest.\$jobnum -ioengine=libaio -direct=1 -thread -rwmixread=${mixread} -rw=randrw -bs=${BS} -size ${fsize} -iodepth=${iodepth} -numjobs=${numjobs_num} -runtime=${runtime} -group_reporting -name=fiotest -time_based=1 -refill_buffers
    sleep 2
done
exit

for BS in $BSSIZE; do
  echo; echo "==================================="
  echo "fio rand write iodepth=$iodepth, bs=$BS"
  echo "------------------"
  $fio -directory=/${DEST}/fiotest/ -filename_format=fiotest.\$jobnum -ioengine=libaio -direct=1 -thread -rw=randwrite -bs=${BS} -size ${fsize} -iodepth=${iodepth} -numjobs=${numjobs_num} -runtime=${runtime} -group_reporting -name=fiotest -time_based=1 -refill_buffers
done
exit

for BS in $BSSIZE; do
  echo; echo "==================================="
  echo "fio rand read iodepth=$iodepth, bs=$BS"
  echo "------------------"
  $fio -directory=/${DEST}/fiotest/ -filename_format=fiotest.\$jobnum -ioengine=libaio -direct=1 -thread -rw=randread -bs=${BS} -size ${fsize} -iodepth=${iodepth} -numjobs=${numjobs_num} -runtime=${runtime} -group_reporting -name=fiotest -time_based=1
done
exit

for BS in $BSSIZE; do
  echo; echo "==================================="
  echo "fio seq write iodepth=$iodepth, bs=$BS"
  echo "------------------"
  $fio -directory=/${DEST}/fiotest/ -filename_format=fiotest.\$jobnum -ioengine=libaio -direct=1 -thread -rw=write -bs=${BS} -size ${fsize} -iodepth=${iodepth} -numjobs=${numjobs_num} -runtime=${runtime} -group_reporting -name=fiotest -time_based=1 -refill_buffers
done

sleep 2
for BS in $BSSIZE; do
  echo; echo "==================================="
  echo "fio seq read iodepth=$iodepth, bs=$BS"
  echo "------------------"
  $fio -directory=/${DEST}/fiotest/ -filename_format=fiotest.\$jobnum -ioengine=libaio -direct=1 -thread -rw=read -bs=${BS} -size ${fsize} -iodepth=${iodepth} -numjobs=${numjobs_num} -runtime=${runtime} -group_reporting -name=fiotest -time_based=1
done

done
