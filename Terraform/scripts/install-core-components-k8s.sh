#!/bin/bash

sudo tee -a /etc/hosts <<EOF
192.168.1.111 k8s-master-1
192.168.1.112 k8s-master-2
192.168.1.113 k8s-master-3
EOF

#Update and upgrade system
sudo apt update -y && sudo apt upgrade -y

#Install NFS Client
sudo apt install nfs-common -y

#Install unzip
echo "===== install aws-cli ====="
sudo apt install unzip -y
which unzip
if [ $? -eq 0 ]; then
    echo "Unzip installed successfully."
else
    echo "Unzip installation failed. Retrying..."
    for i in {1..10}; do
        sudo apt install unzip -y
        which unzip
        if [ $? -eq 0 ]; then
            echo "Unzip installed successfully."
            break
        else
            echo "Retrying in 5 seconds..."
            sleep 5
        fi
    done
fi

#Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
sudo ./aws/install


#Turn of swapoff on system
sudo swapoff -a
sudo sed -i '/swap.img/s/^/#/' /etc/fstab

#Configure module kernel
sudo tee -a /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

#Configure network filter
echo "net.bridge.bridge-nf-call-ip6tables = 1" | sudo tee -a /etc/sysctl.d/kubernetes.conf
echo "net.bridge.bridge-nf-call-iptables = 1" | sudo tee -a /etc/sysctl.d/kubernetes.conf
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.d/kubernetes.conf

#Apply configuration
sudo sysctl --system

#Install necessary packet and add repo docker
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#Install containerd
sudo apt update -y
sudo apt install -y containerd.io

#Configure containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

#Restart and enable containerd
sudo systemctl restart containerd
sudo systemctl enable containerd

#Add repo Kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Install Kubernetes using kubeadm
sudo apt update -y
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl