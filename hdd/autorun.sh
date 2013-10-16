#! /bin/bash

set -x

modprobe rbd
mkdir /test/hdd/result/newconftest -p

for((i=3;i<=4;i++))
do
	mkdir /test/hdd/result/newconftest/test_conf$i

	#restart ceph
	ssh 10.0.0.7 "service ceph -a stop;cp /etc/ceph/all-test/ceph.conf$i /etc/ceph/ceph.conf;/test/mkfs.sh;service ceph -a start"

	for((rbd_num=1;rbd_num<=4;rbd_num++))
	do
		echo conf$i, rbd$rbd_num starting!!!

		#create rbd
		for((m=0;m<=rbd_num-1;m++))
		do
			rbd create rbd-image$m --size 32768
			test1=`rbd list | grep image$m`
			while [ -z $test1 ]
			do
				sleep 1
				test1=`rbd list | grep image$m`				
			done

			rbd map rbd/rbd-image$m
			test2=`ls /dev/ | grep rbd$m`
			while [ -z $test2 ]
			do
				sleep 1
				test2=`ls /dev/ | grep rbd$m`			
			done

			dd if=/dev/zero of=/dev/rbd$m bs=4M count=8000&
			dds[$m]=$!
		done

		for((mm=0;mm<=rbd_num-1;mm++))
		do
			echo waiting for dd rbd$mm of thread ${dds[$mm]}
			wait ${dds[$mm]}
		done

		#mkdir dir 
		mkdir /test/hdd/result/newconftest/test_conf$i/rbd$rbd_num
		test_dir=result/newconftest/test_conf$i/rbd$rbd_num

		#test procedure
		./rbdtest.sh -r $rbd_num -t 5 -o $test_dir -w randall && ./rbdtest.sh -r $rbd_num -t 5 -o $test_dir -w seqall

		#unmap and remove all
		for((n=0;n<=rbd_num-1;n++))
		do
			rbd unmap /dev/rbd$n
			rbd rm rbd/rbd-image$n
		done
	done
done

set +x
