#!/bin/bash
# must be run as sudo

cd /opt

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin \
  net-tools \
  unzip

sudo  alias docker='/usr/bin/docker'

sudo unzip main.zip
sudo sudo find home-lab-main -name ".gitkeep" -type f -delete
sudo mv home-lab-main/home-assistant/* .
sudo rm main.zip
sudo rm -rf home-lab-main
sudo chmod +x backup.sh

sudo docker compose up -d

echo "Current IP: $(ifconfig eno1 | grep 'inet ' | awk '{print $2}')"