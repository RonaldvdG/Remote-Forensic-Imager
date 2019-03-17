#!/bin/bash

workdir=/forensics

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


echo "Everything is done. Please put a public RSA certificate in the folder $workdir/certificates."
echo "This public certificate will be used to encrypt a symmetric key which will be generated later on."
sleep 5

