#!/bin/bash

#Format disk
sudo mkfs.ext4 -m 0 /dev/xvdb

#Create mount directory
sudo mkdir -p /data

#Add fstab to automatic mount 
echo "/dev/xvdb /data ext4 defaults,nofail 0 0" | sudo tee -a /etc/fstab

#Mount
sudo mount -a

#Reload
sudo systemctl daemon-reload

sudo hostnamectl set-hostname "rancher-server"

#Update and upgrade your system
sudo apt update -y && sudo apt upgrade -y

#Install Docker and Docker compose
sudo apt install docker.io -y
sudo apt install docker-compose -y

sudo systemctl start docker
sudo systemctl enable docker

#Write docker file
FILE="docker-compose.yaml"

cat <<EOF > $FILE
services:
  rancher-server:
    image: rancher/rancher:v2.11.1
    container_name: rancher-server
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /data/rancher/data:/var/lib/rancher
    privileged: true
EOF



sudo docker-compose -f $FILE up -d

# Reboot to load new kernel (important)
echo ">> Rebooting to apply new kernel..."
sudo reboot