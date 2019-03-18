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

