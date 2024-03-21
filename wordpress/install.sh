#!/bin/bash

set -x

sudo apt-get update -y
sudo apt-get install wget curl vim -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y

sudo apt-cache policy docker-ce

sudo apt-get install docker-ce -y

#systemctl status docker

sudo usermod -aG docker ubuntu

groups

#---- docker compose ----
sudo apt-get install docker-compose -y

touch wpadminport8123
