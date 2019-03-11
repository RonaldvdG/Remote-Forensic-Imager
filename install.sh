#!/bin/bash

### Variables
workdir=/forensics/

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
echo "===================================================================="
echo "=       Welcome and thanks for using Remote Forensic Imager        ="
echo "=       The required files will be downloaded and installed,       ="
echo "=      please make sure that the device can reach the internet     ="
echo "===================================================================="

sleep 2

apt update && apt upgrade -y && apt install curl -y
	sleep 2

if [ ! -d "$workdir" ]; then
	mkdir $workdir
	mkdir $workdir/scripts
fi

wget -P $workdir/scripts/ https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/basic-installation.sh

sudo sh $workdir/scripts/basic-installation.sh
