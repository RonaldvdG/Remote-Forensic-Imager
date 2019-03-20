#!/bin/bash


if [ ! -f ./symmetric.bin ]
then
	key=symmetric.bin

else
	echo -e "\e[31mNo symmetric key detected.\e[0m"
	echo "The script to generate the symmetric key will be started."
	/forensics/scripts/start.sh

fi

version="0.0.1 (beta)"
workdir=$(</workdir)
vardir=$workdir/vars
username=$(whoami)
fullname=$(<$vardir/fullname)
casenr=$(<$vardir/casenr)
evidencenr=$(<$vardir/evidencenr)
acquireddisk="\e[31mUnknown!\e[0m"
policedisk="\e[31mUnknown!\e[0m"
clear

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
 Officer	:    $fullname \n
 Case number	:    $casenr \n
 Acquired Disk  :    $acquireddisk \n
 Police Disk    :    $policedisk \n
\n
============================================= \n
|    Remote Forensic Imager - EWFAcquire    | \n
============================================= \n
\n
"
echo -e $basic

echo -e "In order to make a full acquisition, the right drives have to be detected."
echo -e "Please make sure that no drive is attached to the device!"
sleep 5

ls /dev/ | grep sd > before

sleep 5

clear
echo -e $basic
echo "Please attach the police disk to the device."
echo "After 30 seconds, the device will check for the attached device..."
sleep 10

ls /dev/ | grep sd > between

sleep 2
diff -e before between | head -n 2 | tail -n 1 > $vardir/policedisk
policehdd=$(<$vardir/policedisk)

echo "The following device is detected:"
echo $policehdd
sleep 3

clear
echo -e $basic
echo "Please attach the acquired disk to the device."
echo "After 30 seconds, the device will check for any attached device..."
sleep 10

ls /dev/ | grep sd > after

sleep 2
diff -e between after | head -n 2 | tail -n 1 > $vardir/acquireddisk
acquiredhdd=$(<$vardir/acquireddisk)

echo "The following device is detected:"
echo $acquiredhdd
sleep 3

clear
echo -e $basic
echo "Now, these are the devices:"
echo "The police HDD is: $policehdd"
echo " "
echo "The acquired HDD is: $acquiredhdd"
sleep 10
