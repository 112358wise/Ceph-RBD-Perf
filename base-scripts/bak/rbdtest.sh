#! /bin/bash

while [ -n "$1" ]
do
	case "$1" in
	-r) rbdnum="$2"
	    shift;;
	-t) exctimes="$2"
	    shift;;
	-o) outputdir="$2"
	    shift;;
	-h) echo "Usage: rbdtest -r rbdnumber -t executetimes -o output directory -w walkload(randread,randwrite,randall,seqread,seqwrite,seqall)"
	    exit;;
	-w) walkload="$2"
	    shift;;
	*)  echo "$1 is not an option"
	    exit;;
	esac
	shift
done

base='/test/base-scripts'
rx=0
tx=0

function init(){
	runday=`date +%Y%m%d`
	runtime=`date +%H%M%S`
	dirname=$runday-$runtime-rbdnum=$rbdnum-exctimes=$exctimes-walkload=$walkload
	logdir=./$outputdir/$dirname
	mkdir $logdir
}

function netio(){
echo $base/netio.sh
}

function randtest(){
	echo "Rand$1 test started"
	for((i=1; i<=$exctimes; i++))
	do
		for((j=0; j<=$rbdnum-1; j++))
		do
			echo "Rand$1 to rbd$j for the $i time..."
			$base/rand$1.sh /dev/rbd$j >> $logdir/rand$1$i.log
			randids[$j]=$!
		done

		for((k=0; k<=$rbdnum-1; k++))
		do
			wait ${randids[$k]}
		done
	done
	echo "Rand$1 test finished"
}


 function seqtest(){
         echo "Seq$1 test started"
         for((i=1; i<=$exctimes; i++))
         do
                for((j=0; j<=$rbdnum-1; j++))
                 do
                         echo "Seq$1 to rbd$j for the $i time..."
                         $base/seq$1.sh /dev/rbd$j >> $logdir/seq$1$i.log
                         seqids[$j]=$!
                 done
 
                 for((k=0; k<=$rbdnum-1; k++))
                 do
                        wait ${seqids[$k]}
                 done
         done
         echo "Seq$1 test finished"
 }



echo "RBD test started with rbdnum $rbdnum, exctimes $exctimes, outputdir $outputdir, walkload $walkload"

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
elif [ $walkload = seqall ]
then
	seqtest read
	seqtest write
elif [ $walkload = seqread ]
then
	seqtest read
elif [ $walkload = seqwrite ]
then
	seqtest write
fi

echo "RBD test finished"
netio




