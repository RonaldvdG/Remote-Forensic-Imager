#!/bin/bash

cd /forensics

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
echo $basic

