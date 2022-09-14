#!/bin/bash

# Install CodeDeploy dependencies.
sudo apt update
sudo apt install ruby-full -y
sudo apt install wget -y

# Install CodeDeploy Agent.
cd /home/ubuntu
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile

# Install Nginx--this will be used to reverse proxy later.
sudo apt install nginx -y