#!/bin/bash

# Update
sudo apt-get update

# Install depends if they are not installed
sudo apt install openjdk-17-jre-headless -y

# Stop any server that might be running on port 8080.
sudo lsof -t -i tcp:8080 | xargs kill -9

# Clean working folder
rm -rf /home/ubuntu/java

# Remap 80 to 8080
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
