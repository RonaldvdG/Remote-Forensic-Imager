#!/bin/bash

### Variables
workdir=/forensics/

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

clear

read -p "Please enter an username: " username
echo "User '$username' will be made..."
echo "Please fill in the information: \n"
adduser $username

usermod -aG sudo $username

if [ ! -d "$workdir" ]; then
	mkdir $workdir
fi


cd $workdir
pwd

#curl -sSL https://url | bash


