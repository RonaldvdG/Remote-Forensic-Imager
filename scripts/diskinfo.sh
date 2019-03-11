#!/bin/bash

cd /forensics

version="0.0.1 (beta)"
workdir=$(pwd)
username=$(whoami)
clear

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
\n
============================================= \n
|     Remote Forensic Imager - DiskInfo     | \n
============================================= \n
\n
"
echo $basic

echo "Please make sure that no disk is attached to the device."
echo "You have 20 seconds to remove any attached disks."
sleep 20

ls /dev/ | grep sd > before

sleep 5

clear
echo $basic
echo "Please attach the acquired disk (donor disk) to the device."
echo "After 20 seconds, the device will check for any attached device..."
sleep 20

ls /dev/ | grep sd > after
HDD=$(diff -e before after | head -n 2 | tail -n 1)

donor=/dev/$HDD

if [ -z $HDD ]; then
	echo "No new mounted device found"
	echo "Please restart the device"
else
	echo "New mounted device found!"
	echo "Device is mounted at $donor ."
fi
