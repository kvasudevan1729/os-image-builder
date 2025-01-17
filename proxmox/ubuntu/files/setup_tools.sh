#!/usr/bin/env bash

set -eu -o pipefail

echo -e '\n==> set up docker ...\n'
echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update && \
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# add ubadmin to docker group and enable docker service
sudo usermod -aG docker ubadmin
sudo systemctl enable docker

# Install Ansible
echo -e '\n==> set up ansible ...\n'
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

ansible --version

# Install Terraform
echo -e '\n==> set up hashicorp tools ...\n'
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
	sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
	sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update
sudo apt-get install -y terraform packer

terraform --version
packer --version

# Install alloy
echo -e '\n==> set up grafan tools ...\n'
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | \
	sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | \
	sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update && sudo apt-get install alloy -y
