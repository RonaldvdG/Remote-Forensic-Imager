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
ls $workdir/policedisk/$casenr/
echo -e "\n\n"
echo "The files will be transferred to the server '$remserver'."
echo "Connection with the server will be made with user '$remuser'."
echo "The files will be stored in the folder '$remfolder'"
echo " "
echo "This process will take a while:"
scp -r $workdir/policedisk $remuser@$remserver:$remfolder
