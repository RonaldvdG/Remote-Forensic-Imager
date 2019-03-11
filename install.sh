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
  Version        :       $version  \n
  Work Directory :       $workdir \n
  Username       :       $username \n
\n
==================================================================== \n
=       Welcome and thanks for using Remote Forensic Imager        = \n
=       The required files will be downloaded and installed,       = \n
=      please make sure that the device can reach the internet     = \n
==================================================================== \n
"
echo $MENU
sleep 2

apt update && apt upgrade -y && apt install wget -y
	sleep 2

if [ ! -d "$workdir" ]; then
	mkdir $workdir
	mkdir $workdir/scripts
fi

clear

if id "$username" >/dev/null 2>&1; then
	deluser $username
	rm -R /home/$username
fi

echo -e "The user $username will be made, please enter the correct information below:"
adduser $username --gecos "Field Officer, NoRoom, NoPhone, NoPhone" --disabled-password
