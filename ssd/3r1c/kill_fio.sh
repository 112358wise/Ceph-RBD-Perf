#!/bin/bash
pids=`ps aux|grep fio|awk '{print $2}'`
for pid in $pids
do
	echo killing $pid
	kill -s 9 $pid
done
