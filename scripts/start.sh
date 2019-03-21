#!/bin/bash

version="0.0.1 (beta)"
workdir=$(</workdir)
username=$(whoami)

cd $workdir

clear

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
\n
"

### Changing the keyboard layout

rm /etc/default/keyboard
echo '# KEYBOARD CONFIGURATION FILE\n\n# Consult the keyboard(5) manual page\n\nXKBMODEL="pc105"\nXKBLAYOUT="us"\nXKBVARIANT=""\nXKBOPTIONS=""\n\nBACKSPACE="guess"' > /etc/default/keyboard

###

if [ ! -f $workdir/certificates/*_pub.pem ];
then
	clear
	echo -e "\e[31mNO PUBLIC CERTIFICATE DETECTED!!\e[0m"
	echo "The acquisition cannot continue safely."
	echo "Please deliver the acquired disk to a forensics technician."
	sleep 15
	exit
fi

echo -e $basic

echo -e "Before the acquisition can start, some information has to be \nfilled in. Please fill in the following information: \n"

## Start collecting information

read -p "What is your full name: " fullname
read -p "What is the case number: " casenr
read -p "What is the evidence number of the disk: " evidencenr
echo	"Is the following date correct?"
date
read -p "(yes/no): " datecorrect

if [ $datecorrect == "yes" ]
then
	echo " "

elif [ $datecorrect == "no" ]
then
	echo "Please fill in the correct date in the following way:"
	echo "Year - Month - Day  Hour:Minute (yyyy-mm-dd HH:MM)"
else
	echo "Please answer with 'yes' or 'no'"
	read -p "Is the give date correct? (yes/no)" datecorrect
fi

read -p "What is the harddisk vendor: " hddvendor
read -p "what is the harddisk serial number: " hddserial
read -p "what is the harddisk model: " hddmodel

echo "Please verify the information: "

echo "Your name is: $fullname"
echo "The case number is: $casenr"
echo "The evidence number is: $evidencenr"
echo "Today the date is: $curdate"
echo "Time of acquisition is: $curtime"
echo "The harddisk is made by $hddvendor. The serial number is"
echo $hddserial
echo "The harddisk model is: $hddmodel"

read -p "Is the information above correct? (yes/no) " confirm

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
	$workdir/scripts/start.sh
fi

## End collecting information

vardir=$workdir/vars

echo $fullname > $vardir/fullname
echo $casenr > $vardir/casenr
echo $evidencenr > $vardir/evidencenr
echo $hddvendor > $vardir/hddvendor
echo $hddserial > $vardir/hddserial
echo $hddmodel > $vardir/hddmodel
echo $workdir/certificates/ > $vardir/certdir
ls $workdir/certificates/ | grep _pub.pem | head -n 2 | tail -n 1 > $vardir/certificate

mkdir $workdir/case$casenr
casedir=$workdir/case$casenr

## Generating symmetric key

echo "A symmetric key will be generated"
openssl rand -base64 32 > $casedir/symmetric.bin
sleep 2

if [ -f $casedir/symmetric.bin ]
then
	echo "Great, symmetric key is generated."

elif [ ! -f $casedir/symmetric.bin ]
then
	clear
	echo -e "\e[31mNo symmetric key detected!\e[0m"
	echo "Something must have gone wrong with generating the symmetric key."
	echo "The device will restart itself to restart the process."
	reboot

fi

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

#echo -e $MENU
#
#read answer
#
#case "$answer" in
#	1) bash $workdir/scripts/acquire.sh ;;
#	2) bash $workdir/scripts/diskinfo.sh ;;
#	q) exit ;;
#esac

$workdir/scripts/acquire.sh
