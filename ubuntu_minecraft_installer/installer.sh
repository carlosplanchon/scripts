#!/bin/bash
# -*- coding: utf-8 -*-

function install_minecraft
{
    echo -e $A'Adding Oracle Java Repository...'$F
    add-apt-repository -y ppa:webupd8team/java
    
    echo -e $A'Updating repositories...'$F
    apt-get update

    echo -e $A'Installing Java8...'$F
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    echo -e $A'License accepted...'$F
    apt-get install -y oracle-java8-installer
  
    echo -e $A'Creating programs folder...'$F
    mkdir ~/programs

    echo -e $A'Creating Minecraft official launcher folder...'$F
    mkdir ~/programs/minecraft_official_launcher

    echo -e $A'Creating Minecraft pirated launcher folder...'$F
    mkdir ~/programs/minecraft_pirated_launcher

    echo -e $A'Creating ~/.minecraft folder...'$F
    mkdir ~/.minecraft

    echo -e $A'Creating ~/.minecraft/versions folder...'$F
    mkdir ~/.minecraft/versions


    echo -e $A'Downloading Minecraft to ~/programs/minecraft_official_launcher...'$F
    wget http://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar -P ~/programs/minecraft_official_launcher -O minecraft.jar

    echo -e $A'Downloading Minecraft pirated launcher...'$F
    wget http://download1639.mediafire.com/21c1ey2qr78g/odn0bfm1nbws2bd/minecraft_launcher_20-6-2016.zip

    echo -e $A'Unzipping Minecraft pirated launcher in ~/programs/minecraft_pirated_launcher...'$F
    unzip minecraft_launcher_20-6-2016.zip -d ~/programs/minecraft_pirated_launcher

    echo -e $A'Removing compressed Minecraft pirated launcher...'$F
    rm minecraft_launcher_20-6-2016.zip


    echo -e $A"Downloading Minecraft launcher's icon..."$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/ubuntu_minecraft_installer/minecraft_launcher_icon.png -P ~/programs/minecraft_official_launcher

    echo -e $A"Downloading Minecraft pirated launcher's icon..."$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/ubuntu_minecraft_installer/minecraft_pirated_launcher_icon.png -P ~/programs/minecraft_pirated_launcher


    echo -e $A'Downloading Minecraft 1.8.9_mods to ~/minecraft/versions...'$F
    wget http://download1275.mediafire.com/u5hggmi75qlg/nn17hukabh41ckn/1.8.9_mods.zip -P ~/.minecraft/versions

    echo -e $A'Downloading Minecraft 1.9.2_mods to ~/minecraft/versions...'$F
    wget http://download1306.mediafire.com/2i01vticz88g/6sngqlr7fv4e0cs/1.9.2_mods.zip -P ~/.minecraft/versions

    echo -e $A'Downloading Minecraft 1.9.4_mods to ~/minecraft/versions...'$F
    wget http://download931.mediafire.com/cruu012btwfg/hgsi5i9vnkuit8t/1.9.4_mods.zip -P ~/.minecraft/versions

    echo -e $A'Downloading Minecraft 1.10_mods to ~/minecraft/versions...'$F
    wget http://download1377.mediafire.com/9om9171ufdug/54zzcmg9c5s3oc4/1.10_mods.zip -P ~/.minecraft/versions

 
    echo -e $A'Creating ~/.local/share/applications folder...'$F
    mkdir ~/.local/share/applications

    echo -e $A'Downloading minecraft_official_launcher.desktop to ~/.local/share/applications...'$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/ubuntu_minecraft_installer/minecraft_official_launcher.desktop -P ~/.local/share/applications -O Minecraft.desktop

    echo -e $A'Downloading minecraft_pirated_launcher.desktop to ~/.local/share/applications...'$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/ubuntu_minecraft_installer/minecraft_pirated_launcher.desktop -P ~/.local/share/applications -O Pirated\ Minecraft.desktop

    echo -e $A'Adding execution flags to Minecraft official launcher...'$F
    chmod +x ~/programs/minecraft_official_launcher/minecraft.jar

    echo -e $A'Adding execution flags to Minecraft pirated launcher...'$F
    chmod +x ~/programs/minecraft_pirated_launcher/shinigima.jar
}

if [ $USER != root ]; then
  echo -e $R'Error: You must be root'
  echo -e $Y'Exiting...'$F
  exit 0
fi
clear

install_minecraft

echo -e $Y'--- READY ---!'$F
echo -e $A'Script execution done - created by: Carlos A. Planchón!'$F
