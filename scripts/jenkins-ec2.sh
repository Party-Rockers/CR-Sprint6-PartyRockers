#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudp apt install wget -y
sudo apt install iptables-persistent -y

# Install Docker
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add Jenkin's repository key to the system
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package repository
sudo apt update -y

# Install Jenkins' dependencies
sudo apt install openjdk-11-jdk -y

# Install Jenkins
sudo apt install jenkins -y

# Start and enable Jenkins
sudo systemctl start jenkins.service
sudo systemctl enable jenkins.service

# Map port 80 to port 8080
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080

# Add Jenkins user to Docker group
sudo usermod -a -G docker jenkins

# Reboot
sudo reboot