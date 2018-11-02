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

cd /home
mal=(hydra john zenmap nmap ripper crack rainbow .mp3 mp3 Kismet Freeciv Ophcrack)
for i in ${mal[@]}
do
ls -RA * | grep $i > /home/malware.txt
find . *"$i" > /home/malwareMore.txt
done
echo "Installing clamav"
echo
apt-get install clamav
systemctl stop clamav-freshclam
freshclam
echo
systemctl start clamav-freshclam
echo "Where would you like clam to scan?"
read res
clamscan -i -r --max-scansize=4000M --max-filesize=4000M ~/$res
echo 
echo
echo "installing rkhunter"

apt-get install rkhunter
rkhunter --update
rkhunter --propupd

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
echo "Users with 0 IDs"
echo
cat /etc/passwd | grep ":0:"
echo
echo
echo "Users that can login"
#if ! grep nologin /etc/passwd
echo
cat /etc/passwd | grep -w "login"
echo
echo 
echo "Sudoers file output"
cat /etc/sudoers | grep -v "#" 
echo
echo 
echo "Sudoers directory"
echo
ls -al /etc/sudoers.d

echo 
echo
echo "Which Users Should You Delete?"

read a

for i in $a
do
 userdel -r $i
 
 groupdel $i
done
echo "Changing rc.local"
echo "exit 0" >> /etc/rc.local

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

a=("bin" "boot" "dev" "etc" "home" "lib" "lib64" "run" "sbin" "usr" "var" "media" "mnt" "opt" "srv")

for i in ${a[@]}
do
        echo "Changing permissions for $i"
        chmod 744 /$i 
done
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
restart lightdm
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config


cat /etc/apt/sources.list | grep -v "#"

echo "Continue with updates?"
read a
 
apt-get update

