#!/bin/bash
# -*- coding: utf-8 -*-

A='\033[1;33m'
R='\033[0;31m'
F='\033[0m'

function copy_wallpaper
{
    echo -e $A'Downloading wallpaper...'$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/wallpaper_downloader/_m_._e__h__9043.jpg -P /usr/share/lubuntu/wallpapers
}

if [ $USER != root ]; then
  echo -e $R'Error: You must be root'
  echo -e $Y'Exiting...'$F
  notify-send 'Download_wallpaper' 'You must execute this script as root'
  exit 0
fi

copy_wallpaper

echo -e $A'Script execution done. - created by: Carlos A. Planchón!'$F
