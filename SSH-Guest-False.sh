#!/bin/bash
echo "allow-guest=false" >> /etc/lightdm/lightdm.conf
restart lightdm
