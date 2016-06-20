#!/bin/bash
# -*- coding: utf-8 -*-

A='\033[1;33m'
R='\033[0;31m'
F='\033[0m'

function copy_logo
{
    echo -e $A'Downloading logo...'$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/lubuntu_logo_numix_style/lubuntu-logo-2.png -P /usr/share/lubuntu/images/
}

if [ $USER != root ]; then
  echo -e $R'Error: You must be root'
  echo -e $Y'Exiting...'$F
  notify-send 'My_lubuntu_logo' 'You must execute this script as root'
  exit 0
fi

copy_logo

echo -e $A'Script execution done. - created by: Carlos A. Planchón!'$F

copy_logo

echo -e $A'Script execution done. - created by: Carlos A. Planchón!'$F
