#! /bin/bash

base='/test/base-scripts'
source $base/netio.sh

while [ -n "$1" ]
do
	case "$1" in
	-t) exctimes="$2"
	    shift;;
	-o) outputdir="$2"
	    shift;;
	-h) echo "Usage: fstest -t executetimes -o output directory -w walkload(randread,randwrite,randall)"
	    exit;;
	-w) walkload="$2"
	    shift;;
	*)  echo "$1 is not an option"
	    exit;;
	esac
	shift
done

function init(){
	runday=`date +%Y%m%d`
	runtime=`date +%H%M%S`
	dirname=$runday-$runtime-rbdnum=$rbdnum-exctimes=$exctimes-walkload=$walkload
	logdir=./$outputdir/$dirname
	mkdir $logdir
}

function randtest(){
	echo "Rand$1 test started"
	for((i=1; i<=$exctimes; i++))
	do
		echo "Rand$1 to /mnt/tt for the $i time..."
		$base/rand$1.sh /mnt/tt >> $logdir/rand$1$i.log
	done
	echo "Rand$1 test finished"
}

echo "FS test started with exctimes $exctimes, outputdir $outputdir, walkload $walkload"

init
netio

if [ $walkload = randall ]
then 
	randtest read
	randtest write
elif [ $walkload = randread ]
then
	randtest read
elif [ $walkload = randwrite ]
then
	randtest write
fi

echo "FS test finished"
netio
rx=$[$rx/(1024*1024)]
tx=$[$tx/(1024*1024)]
echo RX = $rx MB TX = $tx MB
echo "RX = $rx MB TX = $tx MB" > $logdir/netio.log



