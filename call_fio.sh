#!/bin/bash

if [ $# -lt 2 ]; then
  echo "usage: $0 [#files_per_dir] [dir1,dir2,dir3]"
  exit 1
fi

numfiles=$1
dirstr=`echo $2 | sed -r 's:,: :g'`
dirlist=( $dirstr )

for path in ${dirlist[@]}; do
  ## remove the tailing "/".
  if [ ${path:  -1} = "/" ]; then
    path=${path%?}
  fi
  b="/"
  ## retrieve the last component in dir path.
  log=fio_${path##*$b}
  echo "will run fio in dir $path, log=$log"
  #(sh ./run_fio.sh ${numfiles} ${path} > $log 2>&1 && sh ./run_fio_range.sh ${numfiles} ${path} > ${log}_range 2>&1) &
  sh ./run_fio.sh ${numfiles} ${path} > $log 2>&1 &
  #(sh ./run_fio_range.sh ${numfiles} ${path} > ${log}_range 2>&1) &
done
