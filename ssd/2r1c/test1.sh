#! /bin/bash

for((i=0; i<=2; i++))
do
/test/base-scripts/randread.sh /mnt/rbd0/tt >> /test/2r1c/result/randread$i.log & 
id=$!
/test/base-scripts/randread.sh /mnt/rbd1/tt >> /test/2r1c/result/randread$i.log
echo $id
wait $id
done

:<<BLOCK
for((j=0; j<=2; j++))
do 
/test/base-scripts/randwrite.sh /mnt/rbd0/tt >> /test/2r1c/result/randwrite$j.log &
id=$!      
/test/base-scripts/randwrite.sh /mnt/rbd1/tt >> /test/2r1c/result/randwrite$j.log
echo $id  
wait $id 
done 

#:<<BLOCK

for((k=0; k<=2; k++))
do 
/test/base-scripts/randrw.sh /mnt/rbd0/tt >> /test/2r1c/result/randrw$k.log &
id=$!      
/test/base-scripts/randrw.sh /mnt/rbd1/tt >> /test/2r1c/result/randrw$k.log 
echo $id  
wait $id 
done 
BLOCK


