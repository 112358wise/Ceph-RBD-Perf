#! /bin/bash

for size in 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304
do
	echo "size-$size start"
	
	#Start test
	rados bench 60 write -p msx-pool -t 16 -b "$size"KB > $size.log

done






