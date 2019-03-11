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
echo $basic
echo "============================================="
echo "|       Remote Forensic Imager - Menu       |"
echo "============================================="
echo "|          Please make a selection:         |"
echo "|                                           |"
echo "|  1 - Acquire the whole disk               |"
echo "|  2 - See disk information                 |"
echo "|                                           |"
echo "|  q - Press 'q' to stop the acquisition    |"
echo "============================================="
echo "\n"
echo " Your selection: \c"

read answer

case "$answer" in
	1) echo " Whole disk acquisition" ;;
	2) sudo sh $workdir/scripts/diskinfo.sh;;
	q) exit ;;
esac

