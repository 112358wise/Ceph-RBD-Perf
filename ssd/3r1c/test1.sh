#! /bin/bash

LOG_DIR=/test/3r1c/result

:<<BLOCK
echo "randread test started!"
for((i=0; i<=4; i++))
do
/test/base-scripts/randread.sh /mnt/rbd0/tt >> $LOG_DIR/randread$i.log & 
id1=$!
/test/base-scripts/randread.sh /mnt/rbd1/tt >> $LOG_DIR/randread$i.log &
id2=$!
/test/base-scripts/randread.sh /mnt/rbd2/tt >> $LOG_DIR/randread$i.log
echo "thread main finished!"
wait $id1
echo "thread $id1 finished!" 
wait $id2
echo "thread $id2 finished!"
done
echo "randread test finished!"
BLOCK


echo "randwrite test started!"
for((i=0; i<=2; i++))
do
/test/base-scripts/randwrite.sh /mnt/rbd0/tt >> $LOG_DIR/randwrite$i.log & 
id1=$!
/test/base-scripts/randwrite.sh /mnt/rbd1/tt >> $LOG_DIR/randwrite$i.log &
id2=$!
/test/base-scripts/randwrite.sh /mnt/rbd2/tt >> $LOG_DIR/randwrite$i.log &
id3=$!
/test/base-scripts/randwrite.sh /mnt/rbd3/tt >> $LOG_DIR/randwrite$i.log 
echo "thread main finished!"
wait $id1
echo "thread $id1 finished!" 
wait $id2
echo "thread $id2 finished!"
wait $id3
echo "thread $id3 finished!"
done
echo "randwrite test finished!"

:<<BLOCK
echo "randrw test started!"
for((i=0; i<=2; i++))
do
/test/base-scripts/randrw.sh /mnt/rbd0/tt >> $LOG_DIR/randrw$i.log & 
id1=$!
/test/base-scripts/randrw.sh /mnt/rbd1/tt >> $LOG_DIR/randrw$i.log &
id2=$!
/test/base-scripts/randrw.sh /mnt/rbd2/tt >> $LOG_DIR/randrw$i.log
echo "thread main finished!"
wait $id1
echo "thread $id1 finished!" 
wait $id2
echo "thread $id2 finished!"
done
echo "randrw test finished!"

BLOCK


