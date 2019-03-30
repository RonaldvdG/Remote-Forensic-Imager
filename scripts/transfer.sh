#!/bin/bash

version="0.8 (beta)"
workdir=$(</workdir)
vardir=$workdir/vars
username=$(whoami)
fullname=$(<$vardir/fullname)
officerid=$(<$vardir/officerid)
certdir=$(<$vardir/certdir)
certificate=$(<$vardir/certificate)
certificate_loc=$certdir$certificate
casenr=$(<$vardir/casenr)
casedir=$workdir/case$casenr
evidencenr=$(<$vardir/evidencenr)
acquireddisk="\e[31mUnknown!\e[0m"
policedisk="\e[31mUnknown!\e[0m"

remserver=1.2.3.4
remuser=username
remfolder=/forensicsfolder/

clear

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
 Officer        :    $fullname \n
 Officer ID	:    $officerid \n
 Case number    :    $casenr \n
 Acquired Disk  :    $acquireddisk \n
 Police Disk    :    $policedisk \n
\n
============================================= \n
|    Remote Forensic Imager - Transfering   | \n
============================================= \n
\n
"
echo -e $basic

echo "The following files will be tranferred:"
ls -1 $workdir/policedisk/$casenr/ > $vardir/files
ls -1 $workdir/policedisk/$casenr/
echo -e "\n\n"
echo "The files will be transferred to the server '$remserver'."
echo "Connection with the server will be made with user '$remuser'."
echo "The files will be stored in the folder '$remfolder'"
echo " "
echo "This process will take a while:"

files=$(<$vardir/files)

date_start_trans=$(date +%Y-%m-%d && date +%H:%M:%S)
scp -r $workdir/policedisk/$casenr $remuser@$remserver:$remfolder
date_stop_trans=$(date +%Y-%m-%d && date +%H:%M:%S)

### Beginning Chain of Evidence

rm -r $casedir

### Ending Chain of Evidence for acquire.sh

