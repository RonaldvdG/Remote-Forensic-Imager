#!/bin/bash



cd /forensics

if [ ! -f ./symmetric.bin ]
then
	key=symmetric.bin

else
	echo -e "\e[31mNo symmetric key detected.\e[0m"
	echo "The script to generate the symmetric key will be started."
	/forensics/scripts/start.sh

fi

version="0.0.1 (beta)"
workdir=$(pwd)
username=$(whoami)
donor="\e[31mUnknown!\e[0m"
target="\e[31mUnknown!\e[0m"
clear

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
 Acquired Disk  :    $donor \n
 Police Disk    :    $target \n
\n
============================================= \n
|    Remote Forensic Imager - EWFAcquire    | \n
============================================= \n
\n
"
echo -e $basic

echo -e "Make sure that no disk is attached to the device!"

ls /dev/ | grep sd > before

sleep 5

clear
echo -e $basic
echo "Please attach the acquired disk (donor disk) to the device."
echo "After 20 seconds, the device will check for any attached device..."
sleep 20

ls /dev/ | grep sd > after
HDD=$(diff -e before after | head -n 2 | tail -n 1)

donor=/dev/$HDD

