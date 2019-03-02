#!/bin/bash

if [ $# -lt 2 ]; then
  echo "usage: $0 [#files_per_dir] [dir1,dir2,dir3]"
  exit 1
fi

filemaxidx=$(($1 - 1))
dirstr=`echo $2 | sed -r 's:,: :g'`
dirlist=( $dirstr )

bs=1M
blks=1024
expect_fsize=$((1024 * 1024 * blks))

for path in ${dirlist[@]}; do
  dirpath=$path/fiotest
  mkdir -p $dirpath

  echo "will create $((filemaxidx + 1)) files (each=$blks MB) in dir $dirpath"

  for i in `seq 0 $filemaxidx`; do
    filename=${dirpath}/fiotest.${i}
    if [ ! -f "$filename" ]; then
      echo "file $filename not exist, will create ..."
      dd oflag=direct if=/dev/urandom of=$filename bs=$bs count=$blks > /dev/null 2>&1 && echo "have created file $filename" &
    else
      filesize=$(stat -c%s $filename)
      if [ $filesize -lt $expect_fsize ]; then
        echo "file $filename size $filesize < expected size $expect_fsize, will create ..."
        dd oflag=direct if=/dev/urandom of=$filename bs=$bs count=$blks > /dev/null 2>&1 && echo "have created file $filename" &
      else
        echo "file $filename size $filesize exists"
      fi
    fi
  done
done

wait
