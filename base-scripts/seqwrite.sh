#! /bin/bash
echo "start seqwrite"
filename=$1
echo "filename = $filename"
fio -filename=$filename -direct=1 -rw=write -bs=4k -size=30G -numjobs=64 -runtime=120 -group_reporting --name=seqwrite --alloc-size=kb
echo "finish seqwrite"
