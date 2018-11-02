#!/bin/bash

ufw enable 

echo "Enabling cookie protection"
sysctl -n net.ipv4.tcp_syncookies

echo 

echo "Dissabling ipv4 forwarding"
sudo echo 0 > /proc/sys/net/ipv4/ip_forward

echo

echo "Dissable IPV6?"
read YorN

if [ "$YorN" = "Y" ]
then
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
else 
	echo "Canceling"
fi
