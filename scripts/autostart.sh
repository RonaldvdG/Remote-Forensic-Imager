#!/bin/bash

workdir=/forensics

clear
read -p "Do you want root to automatically login? (yes/no) " autologin

if [ $autologin == "yes" ]; then
        echo -e "[Service]\nType=simple\nExecStart=\nExecStart=-/sbin/agetty --autologin root --noclear %I 38400 linux" > /etc/systemd/system/getty@tty1.service.d/override.conf
fi

read -p "Do you want to autostart the acquisition procedure when logged in? (yes/no) " autostart

if [ $autostart == "yes" ]; then
        echo "" >> /root/.profile
        echo "bash $workdir/scripts/start.sh" >> /root/.profile

fi

echo "Make sure that, after this step, a public certificate is put in the folder $workdir/certificates/"
echo "This public certificate will be used to encrypt a symmetric key."
echo "The certificate must end with the syntax '_pub.pem'."
sleep 2

echo " "
echo "Almost done. Just two things still need to be done:"
echo -e "\n\n"

echo "First,"
echo "Put a public certificate in the folder $workdir/certificates "
echo "This certificate needs to end with '_pub.pem' as filename."
echo "This certificate will be used to encrypt the generated symmetric key."

echo -e "\n\n"

echo "Second,"
echo "Put in the right server settings in the variables of the file $workdir/scripts/transfer.sh"
echo "These variables will be used to transfer the data to the right server over SSH."

sleep 5

