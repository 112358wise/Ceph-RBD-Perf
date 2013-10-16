#! /bin/bash
echo "start randrw"
filename=$1
echo "filename = $filename"
fio -filename=$filename -direct=1 -rw=randrw -bs=4k -size=30G -numjobs=64 -runtime=120 -group_reporting --name=randrw
echo "finish randrw"
