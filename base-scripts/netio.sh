#! /bin/bash

base='/test/base-scripts'
rx=0
tx=0
eth=eth7

function netio(){
	dataline=`ifconfig $eth | grep "RX byte"`
	items=`echo $dataline | awk 'BEGIN{FS=" |:"}{print $3" "$8}'`
	i=1
	for item in $items
	do
		if [ $i -eq 1 ]
		then
			rx=$[$item - $rx]
		elif [ $i -eq 2 ]
		then
			tx=$[$item - $tx]
		fi
		i=$[$i + 1]
	done
	#echo rx=$rx tx=$tx
}



