#!/bin/bash
# -*- coding: utf-8 -*-

Y='\033[1;33m'
R='\033[0;31m'
F='\033[0m'

function clean
{
    echo -e $Y'Cleaning apt cache...'$F
    apt clean

    echo -e $Y'Removing orphan packages ...'$F
    apt -y autoremove

    echo -e $Y'Removing old packages...'$F
    apt autoclean

    echo -e $Y'Removing old configuration files...'$F
    apt -y --allow-downgrades --allow-remove-essential --allow-change-held-packages purge $(dpkg -l|grep '^rc'|awk '{print $2}')

    echo -e $Y'Removing old kernels (if exists)...'$F
    ls /boot/ | grep vmlinuz | sed 's@vmlinuz-@linux-image-@g' | sed '$d' | sed '$d' > /tmp/kernelList
    if [ -s /tmp/kernelList ]; then
        echo -e $Y'The following kernels will be removed\n`cat /tmp/kernelList`'$F
        notify-send 'Xubucleaner' 'Operating on kernel.'
        for I in `cat /tmp/kernelList`; do
            apt remove -y $I
            echo -e $Y'Removing $I...'$F
        done
        rm -f /tmp/kernelList
        echo -e $Y'Updating grub...'$F
        update-grub
    fi

    echo -e $Y'Removing thumbnails...'$F
    rm -rf /home/*/.thumbnails/large/*
    rm -rf /home/*/.thumbnails/normal/*

    echo -e $Y'Cleaning cache...'$F
    rm -rf /home/*/.cache/*

    echo -e $Y'Cleaning temporal files...'$F
    rm -rf /tmp/*
    rm -rf /var/tmp/*

    echo -e $Y'Cleaning logs...(if exists in this system)'$F
    rm /usr/bin/TEST.log
    rm /usr/bin/RECV.log
    rm /usr/bin/SENT.log
}

if [ $USER != root ]; then
  echo -e $R'Error: You must be root'
  echo -e $Y'Exiting...'$F
  notify-send 'Xubucleaner' 'You must execute this script as root'
  exit 0
fi
clear
notify-send 'Xubucleaner' 'Starting maintenance...'

echo -e $Y'Emptying trash...'$F
rm -rf /home/*/.local/share/Trash/*
rm -rf /root/.local/share/Trash/*

clean

echo -e $Y'Fixing damaged packages (if exists)...'$F
apt --allow-downgrades --allow-remove-essential --allow-change-held-packages -f install
dpkg --configure -a
apt-get check

echo -e $Y'Getting repository lists...'$F
apt update

echo -e $Y'Updating programs and kernel...'$F
apt --allow-downgrades --allow-remove-essential --allow-change-held-packages -y dist-upgrade

clean

echo -e $Y'--- YOU SHOULD REBOOT THE SYSTEM ---!'$F
echo -e $Y'Script execution done - edited by: Carlos A. Planchón!'$F
notify-send 'Xubucleaner' 'Ready!'
