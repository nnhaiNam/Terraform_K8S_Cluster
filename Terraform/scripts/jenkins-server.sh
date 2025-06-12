#!/bin/bash
sudo hostnamectl set-hostname "jenskin-server"

#Install Java
sudo apt update -y && sudo apt upgrade -y
sudo apt install fontconfig openjdk-21-jre -y
java -version

#Install Jenkins Server
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y

sudo apt-get install jenkins -y

sudo systemctl enable jenkins

sudo systemctl start jenkins


# Install Docker
sudo apt install docker.io -y
sudo usermod -aG docker jenkins
#Install SonarQube
sudo docker run -d -p 9000:9000 --name sonarqube sonarqube:lts-community


# Reboot to load new kernel (important)
echo ">> Rebooting to apply new kernel..."
sudo reboot