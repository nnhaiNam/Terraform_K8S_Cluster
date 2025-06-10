#!/bin/bash

sudo tee -a /etc/hosts <<EOF
192.168.1.40 load_balancer-1
192.168.1.41 load_balancer-2
192.168.1.111 k8s-master-1
192.168.1.112 k8s-master-2
192.168.1.113 k8s-master-3
EOF

#Update and upgrade system
sudo apt update -y && sudo apt upgrade -y

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


#Install HAproxy and Keepalived
sudo apt-get install -y haproxy keepalived