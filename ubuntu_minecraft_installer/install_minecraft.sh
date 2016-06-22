#!/bin/bash
# -*- coding: utf-8 -*-

A='\033[1;33m'
R='\033[0;31m'
F='\033[0m'

function install_minecraft
{
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
    wget http://s3.amazonaws.com/Minecraft.Download/launcher/Minecraft.jar -P ~/programs/minecraft_official_launcher
    mv ~/programs/minecraft_official_launcher/Minecraft.jar ~/programs/minecraft_official_launcher/minecraft.jar

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
    unzip ~/.minecraft/versions/1.8.9_mods.zip -d ~/.minecraft/versions/
    rm ~/.minecraft/versions/1.8.9_mods.zip

    echo -e $A'Downloading Minecraft 1.9.2_mods to ~/minecraft/versions...'$F
    wget http://download1306.mediafire.com/2i01vticz88g/6sngqlr7fv4e0cs/1.9.2_mods.zip -P ~/.minecraft/versions
    unzip ~/.minecraft/versions/1.9.2_mods.zip -d ~/.minecraft/versions/
    rm ~/.minecraft/versions/1.9.2_mods.zip

    echo -e $A'Downloading Minecraft 1.9.4_mods to ~/minecraft/versions...'$F
    wget http://download931.mediafire.com/cruu012btwfg/hgsi5i9vnkuit8t/1.9.4_mods.zip -P ~/.minecraft/versions
    unzip ~/.minecraft/versions/1.9.4_mods.zip -d ~/.minecraft/versions/
    rm ~/.minecraft/versions/1.9.4_mods.zip

    echo -e $A'Downloading Minecraft 1.10_mods to ~/minecraft/versions...'$F
    wget http://download1377.mediafire.com/9om9171ufdug/54zzcmg9c5s3oc4/1.10_mods.zip -P ~/.minecraft/versions
    unzip ~/.minecraft/versions/1.10_mods.zip -d ~/.minecraft/versions/
    rm ~/.minecraft/versions/1.10_mods.zip


    echo -e $A'Creating ~/.local/share/applications folder...'$F
    mkdir ~/.local/share/applications

    echo -e $A'Downloading minecraft_official_launcher.desktop to ~/.local/share/applications...'$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/ubuntu_minecraft_installer/minecraft_official_launcher.desktop -P ~/.local/share/applications 
    mv ~/.local/share/applications/minecraft_official_launcher.desktop  ~/.local/share/applications/Minecraft.desktop 

    echo -e $A'Downloading minecraft_pirated_launcher.desktop to ~/.local/share/applications...'$F
    wget https://raw.githubusercontent.com/carlosplanchon/scripts/master/ubuntu_minecraft_installer/minecraft_pirated_launcher.desktop -P ~/.local/share/applications 
    mv ~/.local/share/applications/minecraft_pirated_launcher.desktop  ~/.local/share/applications/Pirated\ Minecraft.desktop

    echo -e $A'Adding execution flags to Minecraft official launcher...'$F
    chmod 724 ~/programs/minecraft_official_launcher/minecraft.jar

    echo -e $A'Adding execution flags to Minecraft pirated launcher...'$F
    chmod 724 ~/programs/minecraft_pirated_launcher/shinigima.jar
}

install_minecraft

echo -e $Y'--- READY ---!'$F
echo -e $A'Script execution done - created by: Carlos A. Planchón!'$F
