#! /bin/bash

for thread in 2 4 8 16 32 64 128 
do
	echo "thread-$thread start"
	
	#Initial work
	rbd create rbd-image0 --size 32768
	rbd map rbd-image0
	
	#Start test
	fio -filename=/dev/rbd0 -direct=1 -rw=randwrite -bs=4k -size=32G -numjobs=$thread -runtime=60 -group_reporting --name=randwrite > ./thread-$thread.log 

	#Clean work
	rbd unmap /dev/rbd0
	rbd rm rbd-image0
done






