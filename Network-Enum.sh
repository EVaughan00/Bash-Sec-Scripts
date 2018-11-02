#!/bin/bash
echo "Hosts File"
echo
cat /etc/hosts
echo 
echo
echo "Netstat scan"
echo
netstat -lat
echo 
echo
echo "Extended scan"
echo
ss -ln | grep LISTEN | grep -v 127.0
echo 
echo 
echo "What services should I take note of?"
echo
read S
for i in $S
do
ss -ln | grep $i > ./Notes.txt
done
echo
echo "Which ports should I block?"
read a
for port in $a
do
/sbin/iptables -A INPUT -p tcp --destination-port $port -j DROP
done

