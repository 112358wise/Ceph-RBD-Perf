#! /bin/bash

path=$1

for subpath in $path/*
do
	BW=`../calculate.sh $subpath | head -n 7 | tail -1`
	READ=`echo "scale=1;$BW*120" | bc`
	RX=`cat $subpath/netio.log | awk 'BEGIN{FS=" "}{print $3}'`
	RATIO=`echo "scale=4;$READ/$RX" | bc`
	echo READ=$READ RX=$RX READ/RX=$RATIO


done
