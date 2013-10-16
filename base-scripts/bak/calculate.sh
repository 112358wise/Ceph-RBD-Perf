#!/bin/bash 
path=$1
echo "Calculateing files in $path"
cd $path
walkload=`echo $path | awk 'BEGIN{FS="=|-"}{print $8}'`
walkload=${walkload%/}
exctimes=`echo $path | awk 'BEGIN{FS="=|-"}{print $6}'`

function cal(){
	type=$1
	if [ $type = rand ]
	then
		files=`ls randread* randwrite*`
	else
		files=`ls seqread* seqwrite*`
	fi

	totalread=0
	totalwrite=0
	i=1
	flag=read
	readnum=0
	writenum=0
	unit=MB/s

	for file in $files
	do
		if [ -e $file ]
		then	
			items=`cat $file | grep iops | awk 'BEGIN{FS=",|:|="}{print $1" "$7}'`

			for item in $items
			do	
				if [ `expr $i % 2` -eq 1 ]
				then	
					if [ $item = read ]
					then
						flag=read
					else
						flag=write
					fi
				else
					if [ $flag = read ]
					then
						totalread=`echo " scale=3; $totalread + $item" | bc`
						readnum=`expr $readnum + 1`
						reads[$readnum]=$item
					else
						totalwrite=`echo " scale=3; $totalwrite + $item" | bc`
						writenum=`expr $writenum + 1`
						writes[$writenum]=$item
					fi
				fi
			i=`expr $i + 1`
			done
		fi
	done
	
	for((i=1; i<=readnum; i++))
	do
		echo read$i ${reads[$i]}
	done
	
 	if [ $type = rand ]
	then
		echo "Average read iops:"
		echo "scale=1;$totalread/$exctimes" | bc 
	else
		echo "Average read iops ,bandwidth($unit):"
		echo "scale=1;$totalread/$exctimes" | bc 
		echo "scale=3;$totalread/$exctimes*4096/1000000" | bc 
	fi

	for((i=1; i<=writenum; i++))
	do
		echo write$i ${writes[$i]}
	done
	if [ $type = rand ]
	then
		echo "Average write iops:"
		echo  "scale=1;$totalwrite/$exctimes" | bc 
	else
		echo "Avergae write iops, bandwidth($unit):"
		echo "scale=1;$totalwrite/$exctimes" | bc 
		echo  "scale=3;$totalwrite/$exctimes*4096/1000000" | bc 
		fi
}
	

if [ $walkload = randread ] || [ $walkload = randwrite ] || [ $walkload = randall ]
then
	type=rand
	cal $type
else
	type=seq
	cal $type
fi
