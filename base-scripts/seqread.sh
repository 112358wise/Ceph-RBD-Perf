#! /bin/bash
echo "start seqread"
filename=$1
echo "filename = $filename"
fio -filename=$filename -direct=1 -rw=read -bs=4k -size=30G -numjobs=64 -runtime=120 -group_reporting --name=seqread --alloc-size=kb
echo "finish seqread"
