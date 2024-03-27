#!/usr/bin/env bash

# Instructions: https://docs.docker.com/engine/install/ubuntu/

echo -e "\n\n **** Install docker ****"

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli \
  containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo mkdir -p /etc/docker
cat > /tmp/daemon.json << EOF
{
  "default-address-pools":
  [
    {"base":"172.31.0.0/16","size":24}
  ]
}
EOF
sudo cp /tmp/daemon.json /etc/docker/

echo "docker version: $(docker version)"
echo "docker  compose version: $(docker compose version)"
