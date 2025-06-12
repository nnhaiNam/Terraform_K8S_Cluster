#!/bin/bash

#Update and upgrade your system
sudo apt update -y && sudo apt upgrade -y

#Install NFS Server
sudo apt install nfs-server -y

#Create mount directory 
sudo mkdir -p /data
sudo chown -R nobody:nogroup /data
sudo chmod -R 777 /data/

#Format disk
sudo mkfs.ext4 -m 0 /dev/xvdb

#Add fstab to automatic mount
echo "/dev/xvdb /data ext4 defaults,nofail 0 0" | sudo tee -a /etc/fstab

#Mount
sudo mount -a

#Reload
sudo systemctl daemon-reload

sudo hostnamectl set-hostname "nfs-server"

#Configure exports
echo "/data 192.168.1.64/26(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

#Apply and restart
sudo exportfs -rav
sudo systemctl restart nfs-server
