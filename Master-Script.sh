#!/bin/bash

echo "Read Me First!"
echo
echo
echo -e "\033[0;31m"Red"\033[0m = Starting new script section / Starting next function" 
echo -e "\033[0;34m"Blue"\033[0m = Inter-Function Information" 
echo -e "\033[1;33m"Yellow"\033[0m = Requires user Input" 
echo -e "\033[0;35m"Purple"\033[0m = Process is running" 
echo
echo
sleep 5



Manual(){
	echo
	echo -e "\033[0;34m"Manual File Inspection"\033[0m"
	sleep 5
	#Manual File Inspection
	gedit /etc/resolv.conf #Make sure Default 8.8.8.8 name server is used 
	gedit /etc/hosts 
	gedit /root/.bashrc
	gedit ~/.bashrc #Check for weird aliases
	echo deb http://security.ubuntu.com/ubuntu trusty-security universe >> /etc/apt/sources.list
	echo deb-src http://security.ubuntu.com/ubuntu trusty-security universe >> /etc/apt/sources.list
	gedit /etc/apt/sources.list
	echo
	echo -e "\033[0;34m"Contents of sudoers file. Press enter to continue"\033[0m"
	echo
	cat /etc/sudoers | grep -v "#" 
	read next1
	echo
	echo -e "\033[0;34m"Contents of sudoers directory. Press enter to continue."\033[0m"
	echo
	ls -al /etc/sudoers.d
	read next2
	echo
	echo -e "\033[0;34m"Contents of rc.local. Press enter to continue"\033[0m"
	echo
	cat /etc/rc.local | grep -v "#"
	read next3
	visudo 
}

Updates(){
	echo
	echo -e "\033[1;33m"reinstall systemd?"\033[0m (Y/N)" 
	read YorN

	if [ "$YorN" = "Y" ]
	then
		apt-get install systemd -y
	else 
		echo "Canceling"
	fi
	sleep 5
	apt-get update -y
	apt-get dist-upgrade -y
	apt-get install git -y
	apt-get install vim -y
	apt-get install iptables -y
	
}

Scanners(){
	echo
	echo -e "\033[0;34m"Installing Clam"\033[0m"
	sleep 5
	apt-get install clamav -y
	echo
	echo -e "\033[0;34m"Installing rkhunter"\033[0m"
	sleep 5
	apt-get install rkhunter -y
	rkhunter --update
	rkhunter --propupd
}

CronHunt(){
	echo 
	echo -e "\033[0;34m"Making a list of Users"\033[0m"
	cut -d: -f1,3 /etc/passwd | egrep ':[0-9]{4}$' | cut -d: -f1 > /tmp/Lists/listofusers
	echo root >>/tmp/Lists/listofusers
	echo
	echo -e "\033[0;34m"Locating all crontab folders and placing them in /tmp/ListofCronLoc"\033[0m"
	result=`locate cron`
	echo $result > /tmp/Lists/ListofCronLoc
	echo -e "\033[1;33m"Which users should i check for cron use? Users will be put in /tmp/ListofCrons"\033[0m"
	read a
	for i in $a
	do
		crontab -u $i -l | grep -v "#" > /tmp/Lists/ListofCrons
	done
	echo -e "\033[0;34m"Searching Logs for Cron Activity"\033[0m"
	sleep 5
	echo
	echo -e "\033[0;34m"Auth Log crons. Press enter to continue"\033[0m"
	cat /var/log/auth.log | grep cron
	read cont
	echo
	echo -e "\033[0;34m"Syslog crons. Press enter to continue"\033[0m"
	cat /var/log/syslog | grep cron
	read cont2
	echo
	echo -e "\033[0;34m"Installed Hacking Packages. See /tmp/Lists/full-install-list.log for full list. Press enter to continue"\033[0m"
	grep -w install /var/log/dpkg.log > /tmp/Lists/full-install-list.log
	mal=(hydra john zenmap nmap ripper crack rainbow .mp3 mp3 Kismet Freeciv Ophcrack netcat cron crontab anacron)
	for z in ${mal[@]}
	do
		grep -w install /var/log/dpkg.log | grep $z >> /tmp/Lists/malware.txt
	done
	sleep 5
	
}

Scanning(){
	systemctl stop clamav-freshclam
	freshclam
	systemctl start clamav-freshclam
	echo -e "\033[1;33m"Where would you like clam to scan?"\033[0m"
	read res
	clamscan -i -r --max-scansize=4000M --max-filesize=4000M ~$res
	echo -e "\033[0;35m"Clam is Scanning $res"\033[0m" 
	echo
	sleep 5
	echo -e "\033[0;34m"Searching for malware files. Located in /tmp/Lists/malware"\033[0m"
	cd /home
	mal=(hydra john zenmap nmap ripper crack rainbow .mp3 mp3 Kismet Freeciv Ophcrack)
	for i in ${mal[@]}
	do
		ls -RA * | grep $i > /tmp/Lists/malware.txt
		find . *"$i" > /tmp/Lists/malwareMore.txt
	done
	echo
	echo -e "\033[0;35m"Scanning with rkhunter"\033[0m"
	sleep 5
	echo
	rkhunter -c
	echo -e "\033[1;33m"Check rkhunter Log?"\033[0m (Y/N)"
	read YorN
	if [ "$YorN" = "Y" ]
	then
		sudo gedit /var/log/rkhunter.log
	else 
		echo "Canceling"
	fi
	sleep 5
	echo
	echo -e "\033[0;34m"Listing users with 0 IDs"\033[0m"
	echo
	cat /etc/passwd | grep ":0:" 
	echo
	sleep 7
	echo
	echo -e "\033[0;34m"Listing users with that can login"\033[0m"
	echo
	cat /etc/passwd | grep -w "login"
	echo
	sleep 7
}

Networking(){
	echo -e "\033[0;35m"Enabling Ufw"\033[0m" 
	ufw enable 
	echo
	sed -i 's/#net.ipv4.conf.all.send_redirects = 0/net.ipv4.conf.all.send_redirects = 0/' /etc/sysctl.conf
	echo -e "\033[0;35m"Enabling cookie protection"\033[0m" 
	sleep 5
	sysctl -n net.ipv4.tcp_syncookies	
	sed -i 's/#net.ipv4.tcp_syncookies=1/net.ipv4.tcp_syncookies=1/' /etc/sysctl.conf
	echo 
	echo -e "\033[0;35m"Dissabling IPv4 forwarding"\033[0m" 
	sudo echo 0 > /proc/sys/net/ipv4/ip_forward
	echo
	echo -e "\033[1;33m"Dissable IPv6?"\033[0m (Y/N)" 
	read YorN

	if [ "$YorN" = "Y" ]
	then
		echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
	else 
		echo "Canceling"
	fi
	echo "Netstat scan"
	echo
	netstat -lat
	echo 
	sleep 5
	echo
	echo "Extended scan"
	echo
	ss -ln | grep LISTEN | grep -v 127.0
	echo 
	#echo -e "\033[1;33m"Press enter to continue"\033[0m" 
	read next
	echo -e "\033[1;33m"What services should I take note of? Located in /tmp/Lists/Notes"\033[0m" 
	echo
	read S
	for i in $S
	do
		ss -ln | grep $i > /tmp/Lists/Notes.txt
	done
	echo -e "\033[1;33m"Which ports should I block?"\033[0m" 
	read PortList
	for port in $PortList
	do
		/sbin/iptables -A INPUT -p tcp --destination-port $port -j DROP
		echo -e "\033[0;35m"Blocking $port"\033[0m"
	done
	sleep 5
	

}
Permissions(){
	echo -e "\033[0;35m"Changing root directoy permissions"\033[0m" 
	a=("bin" "boot" "dev" "etc" "home" "lib" "lib64" "run" "sbin" "usr" "var" "media" "mnt" "opt" "srv")
	for i in ${a[@]}
	do
	      echo "Changing permissions for $i"
	      chmod 755 /$i 
	done
	echo
	echo -e "\033[1;33m"Dissable Root and guest Login?"\033[0m (Y/N)"
	read YesorNo
	if [ "$YesorNo" = "Y" ]
	then
		cp /etc/passwd /tmp/Backups/passwd.bak
		cp /etc/lightdm/lightdm.conf /tmp/Backups/lightdm.conf
		sed -i 's/root:\/bin\/bash/root:\/usr\/sbin\/nologin/' /etc/passwd
		mkdir /etc/lightdm/lightdm.conf.d
		sh -c 'printf "[SeatDefaults]\nallow-guest=false\n" > /etc/lightdm/lightdm.conf.d/50-no-guest.conf'
	else 
		echo "Canceling"
	fi
	
	#restart lightdm
	echo -e "\033[0;35m"Copying sshd_config to tmp backups"\033[0m"
	sleep 5
	echo -e "\033[0;35m"Dissabling Root SSH"\033[0m" 
	echo
	cp /etc/ssh/sshd_config /tmp/Backups/sshd_config.bak
	sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i 's/PermitRootLogin without-password/PermitRootLogin no/' /etc/ssh/sshd_config
	sed -i 's/IgnoreRhosts no/IgnoreRhosts yes/' /etc/ssh/sshd_config
	sed -i 's/PermitEmptyPasswords yes/PermitEmptyPasswords no/' /etc/ssh/sshd_config
	
}
Passwords(){
	echo -e "\033[0;35m"Copying common-password and common-auth to tmp backups"\033[0m"
	sleep 5
	cp /etc/pam.d/common-password /tmp/Backups/common-password.bak
	cp /etc/pam.d/common-auth /tmp/Backups/common-auth.bak
	sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/' /etc/login.defs
	sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t30/' /etc/login.defs
	sed -i '/obscure sha512/s/$/ use_authtok/' /etc/pam.d/common-password
	sed -i '/(the "Primary" block)/s/$/ \npassword\trequired\t pam_pwhistory.so  remember=5/' /etc/pam.d/common-password
	sed -i '/use_authtok/s/$/ \npassword\trequisite\tpam_cracklib.so retry=3 minlen=10 difok=3 ucredit=-1 lcredit=-1 dcredit=-1  ocredit=-1/' /etc/pam.d/common-password
	sed -i 's/requisite/required/' /etc/pam.d/common-auth
	sed -i '/pam_deny.so/s/$/ \nauth\trequired\tpam_tally2.so\tonerr=fail deny=3 unlock_time=1800/' /etc/pam.d/common-auth
}

Other(){
	echo
	echo -e "\033[1;33m"What Users Should I Delete?"\033[0m"
	read UserDel
	for i in $UserDel
	do
		 userdel -r $i
		 groupdel $i
	done
	echo "exit 0" >> /etc/rc.local
	cp /etc/fstab /tmp/Backups/fstab.bak
	echo 'none /run/shm tmpfs defaults,ro 0 0' >> /etc/fstab
}
	
Starting(){
	echo -e "\033[0;31m"Removing aliases"\033[0m" 
	sleep 5
	unalias -a 
	echo "unalias -a" >> ~/.bashrc
	echo "unalias -a" >> /root/.bashrc
	echo
	echo -e "\033[0;31m"Making tmp Lists Directory"\033[0m" 
	sleep 5
	mkdir /tmp/Lists
	mkdir /tmp/Backups
	chmod 777 /tmp/Lists
	chmod 777 /tmp/Backups
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
	echo -e "\033[0;31m"Inspecting Crontab usage"\033[0m"
	sleep 5
	CronHunt
	echo
	echo -e "\033[0;31m"Scanning For Malware and Vulns"\033[0m"
	sleep 5
	Scanning
	echo
	echo -e "\033[0;31m"Starting Network Security"\033[0m"
	sleep 5
	Networking	
	echo
	echo -e "\033[0;31m"Starting permissions"\033[0m"
	sleep 5
	Permissions
	echo
	echo -e "\033[0;31m"Starting Password Security"\033[0m"
	sleep 5
	Passwords	
	echo
	echo -e "\033[0;31m"Starting Other Operations"\033[0m"
	sleep 5
	Other
}

echo -e "\033[1;33m"Ready To Start Script?"\033[0m (Y/N)"
read YN
if [ "$YN" = "Y" ]
then
	Starting
else
	echo "Canceling"
fi






