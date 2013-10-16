#! /bin/bash
echo "start randread"
filename=$1
echo "filename = $filename"
fio -filename=$filename -direct=1 -rw=randread -bs=4k -size=30G -numjobs=64 -runtime=120 -group_reporting --name=randread
echo "finish randread"
