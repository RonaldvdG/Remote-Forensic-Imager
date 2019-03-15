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
"
echo -e $basic

echo -e "Before the acquire can start, some information has to be \n filled in. Please fill in the following information: \n"

## Start collecting information

read -p "What is your full name: " fullname
read -p "What is the case number: " casenr
read -p "What is the evidence number of the disk: " evidencenr
read -p "What is the date (yyyy-mm-dd): " curdate
read -p "What is the time (HH-MM): " curtime

read -p "What is the harddisk vendor: " hddvendor
read -p "what is the harddisk serial number: " hddserial
read -p "what is the harddisk model: " hddmodel

echo "Please verify the information: "

echo "Your name is: $fullname"
echo "The case number is: $casenr"
echo "The evidence number is: $evidencenr"
echo "Today the date is: $curdate"
echo "Time of acquisition is: $curtime"
echo "The harddisk is made by $hddvendor. The serial number is \n"
echo $hddserial
echo "The harddisk model is: $hddmodel"

read -p "Is the information above correct? (yes or no) " confirm

echo $confirm

if [ $confirm == "yes" ]
then
	echo "The acquisition will continue"
	sleep 3

elif [ $confirm == "no" ]
then
	echo "Please restart the process and make sure the information is correct."
	sleep 3
	exit
else
	echo "Please fill in 'yes' or 'no'."
	echo "The process will be restarted."
	exit
fi

## End collecting information


## 

MENU=" \n
============================================= \n
|       Remote Forensic Imager - Menu       | \n
============================================= \n
|          Please make a selection:         | \n
|                                           | \n
|  1 - Acquire the whole disk               | \n
|  2 - See disk information                 | \n
|                                           | \n
|  q - Press 'q' to stop the acquisition    | \n
============================================= \n
\n
 Your selection: \c"

echo -e $MENU

read answer

case "$answer" in
	1) echo " Whole disk acquisition" ;;
	2) sudo sh $workdir/scripts/diskinfo.sh;;
	q) exit ;;
esac

