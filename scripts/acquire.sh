#!/bin/bash

version="0.0.1 (beta)"
workdir=$(</workdir)
vardir=$workdir/vars
username=$(whoami)
fullname=$(<$vardir/fullname)
casenr=$(<$vardir/casenr)
casedir=$workdir/case$casenr
evidencenr=$(<$vardir/evidencenr)
acquireddisk="\e[31mUnknown!\e[0m"
policedisk="\e[31mUnknown!\e[0m"


if [ ! -f $casedir/symmetric.bin ]
then
        key=symmetric.bin

else
        echo -e "\e[31mNo symmetric key detected.\e[0m"
        echo "The script to generate the symmetric key will be started."
        $workdir/scripts/start.sh

fi

clear

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
|    Remote Forensic Imager - EWFAcquire    | \n
============================================= \n
\n
"
echo -e $basic

echo -e "In order to make a full acquisition, the right drives have to be detected."
echo -e "Please make sure that no drive is attached to the device!"
sleep 5

ls /dev/ | grep sd > before

sleep 5

clear
echo -e $basic
echo "Please attach the police disk to the device."
echo "After 30 seconds, the device will check for the attached device..."
sleep 10

ls /dev/ | grep sd > between

sleep 2
diff -e before between | head -n 2 | tail -n 1 > $vardir/policedisk
policehdd=$(<$vardir/policedisk)

echo "The following device is detected:"
echo $policehdd
policedisk=/dev/$policehdd
echo $policedisk > $vardir/policedisk

policepoint=$workdir/policedisk
sleep 3

clear
echo -e $basic
echo "Please attach the acquired disk to the device."
echo "After 30 seconds, the device will check for any attached device..."
sleep 10

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
echo " "
echo "The policedisk will be mounted at the following point:"
echo " "
echo "Please do not remove the disks unless stated otherwise!"
sleep 10

clear
echo -e $basic
echo "The police disk will be mounted."
mount /dev/$policehdd1 $policepoint

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

### Beginning imaging

# IMAGE COMMAND HERE
# dc3dd if=/dev/sdb ssz=4096 cnt=2097152 hash=sha256 log=dc3dd_HDD_sha256.txt of=dc3dd_HDD.img
# dc3dd if=/dev/sdb ssz=4096 cnt=2097152 hash=sha256 log=dc3dd_fast_compression1_sha256.txt | gzip -1 > dc3dd_fast_compression1.img.gz

echo "============================================="
echo "        Imaging the disk is completed        "
echo "============================================="
echo " "
echo " "
# HASHING OF IMAGE HERE
# HASHING THE SYMMETRIC KEY HERE
# sha256sum symmetric.bin > symmetric.bin.sha256

### Encrypting the image

# ENCRYPTING COMMAND HERE
# openssl enc -aes-256-cbc -salt -in original/project_dc3dd_uncompressed.img -out encrypt/project_dc3dd_uncompressed.enc -pass file:keys/symmetric.bin
echo "============================================="
echo "      Encrypting the image is completed      "
echo "============================================="
echo " "
echo " "
# HASHING OF ENCRYPTED IMAGE HERE
# sha256sum ENCRYPTED.img


# REMOVING THE UNENCRYPTED IMAGE
# rm unencrypted.img


### Encrypting the key and hash

# ENCRYPT THE SYMMETRIC KEY HERE
# openssl rsautl -encrypt -inkey case1234_pub.pem -pubin -in symmetric.bin -out ../encrypt/symmetric.enc

# ENCRYPT THE HASH HERE
# openssl rsautl -encrypt -inkey case1234_pub.pem -pubin -in symmetric.bin -out ../encrypt/symmetric.enc

echo "============================================="
echo "      Encrypting of the key is completed     "
echo "============================================="
echo " "
echo " "

# REMOVE THE UNENCRYPTED SYMMETRIC KEY HERE
# REMOVE THE UNENCRYPTED HASH HERE

### Begin script for sending the files over the network
