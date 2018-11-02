#!/bin/bash
cd /home
mal=(hydra john zenmap nmap ripper crack rainbow .mp3 mp3)
for i in ${mal[@]}
do
ls -RA * | grep $i > /home/malware.txt
find . *"$i" > /home/malwareMore.txt
done
