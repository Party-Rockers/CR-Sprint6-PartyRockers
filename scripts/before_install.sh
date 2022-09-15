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

# Save iptables
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
sudo apt-get -y install iptables-persistent

sudo iptables-save > /etc/iptables/rules.v4
sudo ip6tables-save > /etc/iptables/rules.v6
