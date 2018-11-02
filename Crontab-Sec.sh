#!/bin/bash

result=`locate cron`
echo 
echo "Possible locations for cron" 
echo
echo $result
echo 
echo
echo "Whihch users should I check for crontab use?"
read a

for i in $a
do
crontab -u $i -l | grep -v "#"
done

