#! /bin/bash
echo "start randwrite"
filename=$1
echo "filename = $filename"
fio -filename=$filename -direct=1 -rw=randwrite -bs=4k -size=30G -numjobs=64 -runtime=120 -group_reporting --name=randwrite
echo "finish randwrite"
