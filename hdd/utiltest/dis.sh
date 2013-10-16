#! /bin/bash

osdnum=18

function getosds(){
	osds=`ceph osd map msx-pool $objname | awk -F '[][]| |,' '{print $15" "$16}'`
}

function setobjnumofosd(){
	for((i=0; i<=$osdnum; i++))
	do
		objnumofosd[$i]=0
	done
}

filename="file1"
setobjnumofosd

for((i=0; i<100; i++))
do
	objname=$filename.$i
	getosds $objname

	for osd in $osds
	do
		#echo obj: $objname in osd$osd
		objnumofosd[$osd]=`expr ${objnumofosd[$osd]} + 1`
	done	
done

for((i=0; i<$osdnum; i++))
do
	echo objnumosdsod$i = ${objnumofosd[$i]}
done
