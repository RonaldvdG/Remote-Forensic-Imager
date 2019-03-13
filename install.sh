#!/bin/bash

version="0.0.1 (beta)"

### Variables
workdir=/forensics
username=fieldofficer

clear

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
	echo "The script cannot be executed with the current user."
	echo "Please run the script as root"
	sleep 5
	clear
	exit
fi

clear


### Menu
MENU="
  Version        :       $version
  Work Directory :       $workdir
  Username       :       $username

====================================================================
|       Welcome and thanks for using Remote Forensic Imager        |
|       The required files will be downloaded and installed,       |
|      please make sure that the device can reach the internet     |
====================================================================
 
"
echo -e $MENU
sleep 2

apt update && apt upgrade -y && apt install wget ewf-tools -y
	sleep 2

if [ ! -d "$workdir" ]; then
	mkdir $workdir
	mkdir $workdir/scripts
fi

clear
echo -e $MENU
if id "$username" >/dev/null 2>&1; then
	deluser $username
	rm -R /home/$username
fi

echo -e "The user $username will be made, please enter the correct information below:"
adduser $username --gecos "Field Officer, NoRoom, NoPhone, NoPhone" --disabled-password

clear
