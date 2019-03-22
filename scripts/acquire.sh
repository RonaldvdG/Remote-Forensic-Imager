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
acquireddisk="\e[31mUnknown!\e[0m"
policedisk="\e[31mUnknown!\e[0m"


clear

if [ ! -f $casedir/symmetric.bin ]
then

	echo -e "\e[31mNo symmetric key detected.\e[0m"
        echo "The script to generate the symmetric key will be started."
        echo $casedir
        echo $casedir/symmetric.bin
        sleep 10
        $workdir/scripts/start.sh

else
	symkey=$casedir/symmetric.bin

fi

basic=" \n
 Version        :    $version \n
 Work Directory :    $workdir \n
 Username       :    $username \n
 Officer	:    $fullname \n
 Case number	:    $casenr \n
 Acquired Disk  :    $acquireddisk \n
 Police Disk    :    $policedisk \n
\n
============================================= \n
|     Remote Forensic Imager - Imaging      | \n
============================================= \n
\n
"
echo -e $basic

echo -e "In order to make a full acquisition, the right drives have to be detected."
read -p "Press [ENTER] when neither the police and the acquired disk is attached to the device."
sleep 5

ls /dev/ | grep sd > before

sleep 5

clear
echo -e $basic
echo "Please attach the police disk to the device."
read -p "Press [ENTER] when the police disk is attached to the device."
sleep 5

ls /dev/ | grep sd > between

sleep 2
diff -e before between | head -n 2 | tail -n 1 > $vardir/policedisk
policehdd=$(<$vardir/policedisk)

echo "The following device is detected:"
echo $policehdd
policedisk=/dev/$policehdd
echo $policedisk > $vardir/policedisk


policepoint=$workdir/policedisk

if [ ! -d $policepoint ]
then
	mkdir $policepoint
elif [ -d $policepoint ]
then
	echo "Mountpoint exists. Using the existing point"
fi
sleep 3

clear
echo -e $basic
echo "Please attach the acquired disk to the device."
read -p "Press [ENTER] when the acquired disk is attached to the device."
sleep 5

ls /dev/ | grep sd > after

sleep 2
diff -e between after | head -n 2 | tail -n 1 > $vardir/acquireddisk
acquiredhdd=$(<$vardir/acquireddisk)

echo "The following device is detected:"
echo $acquiredhdd
acquireddisk=/dev/$acquiredhdd
echo $acquireddisk > $vardir/acquireddisk

sleep 3

clear
echo -e $basic
echo "Now, these are the devices:"
echo "The police HDD is: $policehdd"
echo " "
echo "The acquired HDD is: $acquiredhdd"
echo " "

read -p "Press [ENTER] if this information is correct. If not, restart the system."

echo " "
echo "The policedisk will be mounted at the following point:"
echo "$policepoint"
echo "Please do not remove the disks unless stated otherwise!"
sleep 5

clear
echo -e $basic
echo "The police disk will be mounted."
mount /dev/$policehdd\1 $policepoint

sleep 5

clear
echo -e $basic
echo "The acquisition of the acquired HDD will begin..."
echo "This process could take a while."
echo "When this process is done, you will be notified."
sleep 5

clear
echo -e "\e[31mPlease do not turn off the device and do not press any key!\e[0m"
echo "The acquisition is in process. You will be notified when the acquisition is done."
echo "Until then, please do not interrupt the device."
echo " "
echo " "
policedir=$policepoint/$casenr
mkdir $policedir
cd $policedir

### Beginning imaging

# IMAGE COMMAND HERE
dc3dd if=$acquireddisk ssz=4096 cnt=2097152 hash=sha256 log=dc3dd_$casenr.compressed.img.gz.sha256 | gzip -1 > dc3dd_$casenr.compressed.img.gz

echo "============================================="
echo "        Imaging the disk is completed        "
echo "============================================="
echo " "
echo " "
echo "Acquireddisk = $acquireddisk"
echo "Shafile = dc3dd_$casenr.sha256.txt"
echo "Gzip file = dc3dd_$casenr.compressed.img.gz"
echo " "

sha256sum $symkey > symmetric.bin.sha256

echo "The imaging was successful, please remove the acquired disk."
echo "This disk is no longer needed for the acquisition."
echo "The policedisk needs to remain attached!"
echo ""
read -p "Press [ENTER] when the acquired disk is removed"


### Encrypting the image

# ENCRYPTING COMMAND HERE

echo "The image will now be encrypted. This will take a while."
echo "Please wait.."
openssl enc -aes-256-cbc -salt -in dc3dd_$casenr.compressed.img.gz -out dc3dd_$casenr.compressed.img.gz.enc -pass file:$symkey

echo "============================================="
echo "      Encrypting the image is completed      "
echo "============================================="
echo " "
echo " "
echo "Inputfile = dc3dd_$casenr.compressed.img.gz"
echo "Outputfile = dc3dd_$casenr.compressed.img.gz.enc"
echo "Key = file:$symkey"
echo " "

sha256sum dc3dd_$casenr.compressed.img.gz.enc > dc3dd_$casenr.compressed.img.gz.enc.sha256

# REMOVING THE UNENCRYPTED IMAGE
# rm unencrypted.img

### Encrypting the key and hash

# Below, encrypting the symmetric key
openssl rsautl -encrypt -inkey $certificate_loc -pubin -in $symkey -out symmetric.bin.enc

#
# openssl rsautl -encrypt -inkey case1234_pub.pem -pubin -in symmetric.bin -out ../encrypt/symmetric.enc

echo "============================================="
echo "      Encrypting of the key is completed     "
echo "============================================="
echo " "
echo " "
echo "Inkey = $certificate_loc"
echo "Pubin = $symkey"
echo "Output = symmetric.bin.enc"
echo " "

### Removing the unencrypted files
echo "============================================="
echo "        Removing the unencrypted files       "
echo "============================================="

rm -r $workdir/after $workdir/before $workdir/between $workdir/$casenr

### Begin script for sending the files over the network

$workdir/scripts/transfer.sh
