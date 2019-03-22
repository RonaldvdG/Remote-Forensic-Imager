#!/bin/bash

version="0.8 (beta)"
workdir=$(</workdir)
vardir=$workdir/vars
username=$(whoami)
fullname=$(<$vardir/fullname)
certdir=$(<$vardir/certdir)
certificate=$(<$vardir/certificate)
certificate_loc=$certdir$certificate
casenr=$(<$vardir/casenr)
casedir=$workdir/case$casenr
evidencenr=$(<$vardir/evidencenr)
acquireddisk=$(<$vardir/acquireddisk)
policedisk=$(<$vardir/policedisk)

remserver=145.100.104.173
remuser=rgaag
remfolder=/large/frank/demo/

clear

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
 Officer        :    $fullname \n
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
ls $workdir/policedisk/$casenr/ > $vardir/files
echo -e "\n\n"
echo "The files will be transferred to the server '$remserver'."
echo "Connection with the server will be made with user '$remuser'."
echo "The files will be stored in the folder '$remfolder'"
echo " "
echo "This process will take a while:"

files=$(<$vardir/files)

date_start_trans=$(date +%Y-%m-%d && date +%H:%M:%S)
scp -r $workdir/policedisk $remuser@$remserver:$remfolder
date_stop_trans=$(date +%Y-%m-%d && date +%H:%M:%S)

### Beginning Chain of Evidence

coe="###### Transportation part starts here ###### \n
\n
The following files were transported: \n
$files \n
\n \n
The transportation started at: $date_start_trans
The transportation was finished at: $date_stop_trans
\n
"

echo -e $coe >> $casedir/Chain_of_Evidence.txt

sha256sum $casedir/Chain_of_Evidence.txt > $casedir/Chain_of_Evidence.txt.sha256
scp $casedir/Chain_of_Evidence* $remuser@$remserver:$remfolder

### Ending Chain of Evidence for acquire.sh

