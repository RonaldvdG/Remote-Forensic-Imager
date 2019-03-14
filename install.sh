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
MENU=" \n
  Version        :       $version \n
  Work Directory :       $workdir \n
  Username       :       $username \n
 \n
==================================================================== \n
|       Welcome and thanks for using Remote Forensic Imager        | \n
|       The required files will be downloaded and installed,       | \n
|      please make sure that the device can reach the internet     | \n
==================================================================== \n
  \n
"
echo -e $MENU
sleep 2

apt update && apt upgrade -y && apt install wget ewf-tools -y
	sleep 2

if [ ! -d "$workdir" ]; then
	mkdir $workdir
	mkdir $workdir/scripts
	mkdir $workdir/certificates

else
	rm -R $workdir

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

echo -e $MENU
echo "Retrieving the necessary files: ..."
sleep 2

wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/diskinfo.sh -P $workdir/scripts/
wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/ewfacquire.sh -P $workdir/scripts
wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/start.sh -P $workdir/scripts

chown -R $username $workdir
chgrp -R $username $workdir
chmod 755 -R $workdir

read -p "Do you want $username to automatically login? (yes/no) " autologin

if [ $autologin == "yes"  ]; then
	echo -e "[Service]\nType=simple\nExecStart=\nExecStart=-/sbin/agetty --autologin $username --noclear %I 38400 linux" > /etc/systemd/system/getty@tty1.service.d/override.conf
fi

read -p "Do you want to autostart the acquisition procedure when logged in? (yes/no) " autostart

if [ $autostart == "yes" ]; then
	echo "" >> /home/$username/.profile
	echo "bash $workdir/scripts/start.sh" >> /home/$username/.profile

fi

echo -e $MENU
echo "Everything is done. Please put a public RSA certificate in the folder $workdir/certificates."
echo "This public certificate will be used to encrypt a symmetric key which will be generated later on."
sleep 5
