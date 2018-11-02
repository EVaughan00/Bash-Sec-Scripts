#!/bin/bash


cat /etc/apt/sources.list | grep -v "#"

echo "Continue with updates?"
read a
 
apt-get update
apt-get upgrade
