#!/bin/bash
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
