#!/bin/bash
# -*- coding: utf-8 -*-

Y="\033[1;33m"
R="\x1b[38;5;9m\x1b[1m"
F="\033[0m"


function purge_old_kernels
{
    echo -e $Y"· Removing old kernels (if there are)..."$F
    # purge-old-kernels - remove old kernel packages
    #    Copyright (C) 2012 Dustin Kirkland <kirkland -(at)- ubuntu.com>
    #
    #    Authors: Dustin Kirkland <kirkland-(at)-ubuntu.com>
    #             Kees Cook <kees-(at)-ubuntu.com>
    #
    # NOTE: This script will ALWAYS keep the currently running kernel
    # NOTE: Default is to keep 2 more.
    KEEP=1
    APT_OPTS=
    while [ ! -z "$1" ]; do
        case "$1" in
            --keep)
                KEEP="$2"
                shift 2
            ;;
            *)
                APT_OPTS="$APT_OPTS $1"
                shift 1
            ;;
        esac
    done

    # Build our list of kernel packages to purge.
    CANDIDATES=$(ls -tr /boot/vmlinuz-* | head -n -${KEEP} | grep -v "$(uname -r)$" | cut -d- -f2- | awk '{print "linux-image-" $0 " linux-headers-" $0}' )
    for c in $CANDIDATES; do
        dpkg-query -s "$c" >/dev/null 2>&1 && PURGE="$PURGE $c"
    done

    if [ -z "$PURGE" ]; then
        echo -e $Y"- No kernels are eligible for removal."$F
    fi

    sudo apt $APT_OPTS remove -y --purge $PURGE;    
}


function system_clean
{
    echo -e $Y"· Removing orphan packages ..."$F
    apt -y --purge autoremove

    echo -e $Y"· Cleaning apt cache..."$F
    apt -y clean

    echo -e $Y"· Removing old packages..."$F
    apt -y autoclean
    # --- DEV --- #
    echo -e $Y"· Removing old configuration files..."$F
    sudo deborphan -n --find-config | xargs sudo apt-get -y --purge autoremove

    purge_old_kernels
}


function user_trash_clean
{
    echo -e $Y"· Emptying trash..."$F
    rm -rf /home/*/.local/share/Trash/*
    rm -rf /root/.local/share/Trash/*

    echo -e $Y"· Removing thumbnails..."$F
    rm -rf /home/*/.thumbnails/large/*
    rm -rf /home/*/.thumbnails/normal/*

    echo -e $Y"· Cleaning cache..."$F
    rm -rf /home/*/.cache/*

    echo -e $Y"· Cleaning temporal files..."$F
    rm -rf /tmp/*
    rm -rf /var/tmp/*
}

function maintenance
{    
    echo -e $Y"--- Xubucleaner ---"$F
    echo -e $Y"· Starting maintenance..."$F

    user_trash_clean
    system_clean

    echo -e $Y"· Fixing damaged packages (if there are)..."$F
    apt --allow-downgrades --allow-change-held-packages -f install
    dpkg --configure -a
    apt-get check

    echo -e $Y"· Getting repository lists..."$F
    apt update

    echo -e $Y"· Updating programs and kernel..."$F
    apt --allow-downgrades --allow-change-held-packages -y full-upgrade

    system_clean

    # Check to see if a reboot is required.
    if [ -f /var/run/reboot-required ]; then
        echo -e $Y"·! YOU SHOULD REBOOT THE SYSTEM TO FINISH APPLYING UPDATES!"$F
    fi
}

if [ $USER != root ]; then
  echo -e $R"-! Error: You must be root."
  echo -e $Y"· Exiting..."$F
  exit 0
fi
clear

maintenance

echo -e $Y"· Script execution done - edited by: Carlos A. Planchón!"$F
echo -e $Y"· Xubucleaner > Ready!"$F
