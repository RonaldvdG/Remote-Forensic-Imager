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

echo -e "\e[31mBE AWARE!\e[0m"
echo -e "Also, the script will make \e[31m$workdir!\e[0m as an working directory."

echo -e $MENU
sleep 2

apt update && apt upgrade -y && apt install wget ewf-tools -y
	sleep 2

if [ ! -d "$workdir" ]; then
	mkdir $workdir
	mkdir $workdir/scripts
	mkdir $workdir/certificates
	mkdir $workdir/vars

else
	rm -R $workdir
	mkdir $workdir
	mkdir $workdir/scripts
	mkdir $workdir/certificates
	mkdir $workdir/vars
fi

clear
echo -e $MENU
echo "Retrieving the necessary files: ..."
sleep 2

wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/diskinfo.sh -P $workdir/scripts/
wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/ewfacquire.sh -P $workdir/scripts/
wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/start.sh -P $workdir/scripts/
wget https://raw.githubusercontent.com/RonaldvdG/Remote-Forensic-Imager/master/scripts/autostart.sh -P $workdir/scripts/

chmod -R +x $workdir/

clear

### Writing variables

echo $workdir > /workdir

###


echo -e $MENU
echo "Congratulations, everything is downloaded. In order to start the next step, please enter the following line:"
echo "'sudo $workdir/scripts/autostart.sh'"
sleep 2
