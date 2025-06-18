#!/bin/bash

# Update and upgrade your system
sudo apt update -y && sudo apt upgrade -y

# Install NFS Server
sudo apt install nfs-server -y

# Format disk
sudo mkfs.ext4 -m 0 /dev/xvdb

# Create mount directory
sudo mkdir -p /data

# Add fstab to auto-mount the disk
echo "/dev/xvdb /data ext4 defaults,nofail 0 0" | sudo tee -a /etc/fstab

# Mount the disk
sudo mount -a

# Set permissions after mount to avoid being overridden
sudo chown -R nobody:nogroup /data
sudo chmod -R 777 /data

# Reload daemon (not strictly necessary here, but included for completeness)
sudo systemctl daemon-reexec

# Set hostname
sudo hostnamectl set-hostname "nfs-server"

# Configure exports
echo "/data 192.168.1.64/26(rw,sync,no_subtree_check,no_root_squash)" | sudo tee -a /etc/exports

# Apply export changes and restart NFS server
sudo exportfs -rav
sudo systemctl restart nfs-server
