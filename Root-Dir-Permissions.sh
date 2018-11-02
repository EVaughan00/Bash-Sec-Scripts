#!/bin/bash

a=("bin" "boot" "dev" "etc" "home" "lib" "lib64" "run" "sbin" "usr" "var" "media" "mnt" "opt" "srv")

for i in ${a[@]}
do
        echo "Changing permissions for $i"
        chmod 744 /$i 
done

