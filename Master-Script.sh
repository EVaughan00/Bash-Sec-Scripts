#!/bin/bash

echo "Read Me First!"
echo
echo
echo -e "\033[0;31m"Red"\033[0m = Starting new script section / Starting next function" 
echo -e "\033[0;34m"Blue"\033[0m = Inter-Function Information" 
echo -e "\033[1;33m"Yellow"\033[0m = Requires user Input" 
echo
echo
sleep 5


echo -e "\033[1;33m"Ready To Start Script?"\033[0m (Y/N)"
read YN
if [ "$YN" = "Y" ]
then
	Starting
else
	echo "Canceling"
fi


Starting(){
	echo -e "\033[0;31m"Making tmp Lists Directory"\033[0m" 
	sleep 5
	mkdir /tmp/Lists
	echo
	echo -e "\033[0;31m"Manual File Inspection"\033[0m"
	Manual
	echo
	echo -e "\033[0;31m"Performing Updates and Package Installs"\033[0m"
	sleep 5
	Updates
	echo
	echo -e "\033[0;31m"Installing Scanners and ToolKits"\033[0m"
	sleep 5
	Scanners
	echo
	echo -e "\033[0;31m"Performing Updates and Package Installs"\033[0m"
}

Manual(){
	echo
	echo -e "\033[0;34m"Manual Edits"\033[0m"
	sleep 5
	#Manual File Inspection
	gedit /etc/resolv.conf #Make sure Default 8.8.8.8 name server is used 
	gedit /etc/hosts 
	gedit /root/.bashrc
	gedit ~/.bashrc #Check for weird aliases
	gedit /etc/apt/sources.list | grep -v "#"
	visudo 
}

Updates(){
	echo
	echo "Updating"
	sleep 5
	apt-get update -y
	apt-get dist-upgrade -y
	apt-get install git -y
	apt-get install vim -y
}

Scanners(){
	echo
	echo -e "\033[0;34m"Installing and Running Clam"\033[0m"
	sleep 5
	apt-get install clamav -y
	systemctl stop clamav-freshclam
	freshclam
	systemctl start clamav-freshclam
	echo -e "\033[1;33m"Where would you like clam to scan?"\033[0m"
	read res
	clamscan -i -r --max-scansize=4000M --max-filesize=4000M ~/$res
	echo "Clam is Scanning $res"
}



echo "Continue?" 
read Cont1
result=`locate cron`
echo 
echo "Possible locations for cron" 
echo
echo $result > /tmp/Lists/ListofCronLoc
echo 
echo
echo "Making list of users"
cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1 > /tmp/Lists/listofusers

echo root >>/tmp/Lists/listofusers
echo
echo "Which users should I check for crontab use? Result will be put in ListofCrons"
read a

for i in $a
do
crontab -u $i -l | grep -v "#" > /tmp/Lists/ListofCrons
done

echo "Looking for hacking tools and bad files"

cd /home
mal=(hydra john zenmap nmap ripper crack rainbow .mp3 mp3 Kismet Freeciv Ophcrack)
for i in ${mal[@]}
do
ls -RA * | grep $i > /tmp/Lists/malware.txt
find . *"$i" > /tmp/Lists/malwareMore.txt
done

echo 
echo "Continue?"
read Cont3
echo
echo "installing rkhunter"

apt-get install rkhunter -y
rkhunter --update
rkhunter --propupd

ufw enable 

echo "Enabling cookie protection"
sysctl -n net.ipv4.tcp_syncookies

echo 

echo "Dissabling ipv4 forwarding"
sudo echo 0 > /proc/sys/net/ipv4/ip_forward

echo

echo "Dissable IPV6? (Y/N)"
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
cat /etc/passwd | grep -w "login"
echo
echo "Dissable root Login? (Y/N)"
read YesorNo
if [ "$YesorNo" = "Y" ]
then
	sed -i 's//bin/bash//usr/sbin/nologin/' /etc/Passwd
else 
	echo "Canceling"
fi
echo 

echo
echo 
echo "Sudoers file output"
cat /etc/sudoers | grep -v "#" 
echo
echo 


echo "Sudoers directory"
echo
ls -al /etc/sudoers.d

echo "Continue?"
read Cont4
echo
echo "Which Users Should I Delete?"

read UserDel

for i in $UserDel
do
 userdel -r $i
 
 groupdel $i
done
echo "Changing rc.local"
echo "exit 0" >> /etc/rc.local
echo 
echo
echo "rc.local contents"
cat /etc/rc.local | grep -v "#"
echo
echo "Continue?"
read Cont2

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
read PortList
for port in $PortList
do
/sbin/iptables -A INPUT -p tcp --destination-port $port -j DROP
done

a=("bin" "boot" "dev" "etc" "home" "lib" "lib64" "run" "sbin" "usr" "var" "media" "mnt" "opt" "srv")

for i in ${a[@]}
do
      echo "Changing permissions for $i"
      chmod 755 /$i 
done

echo "Continue?"
read cont5
echo "dissabling Guest Access (Will also need to restart lightdm)"

echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
#restart lightdm

echo "Dissabling ssh root login"
echo
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

echo "Adding maximum password life"





