#!/usr/bin/env bash

# hashicorp apt file needs a minor change (see https://github.com/hashicorp/terraform/issues/32622)

echo -e "\n\n **** Install Hashicorp tools - terraform and packer ****"

wget -O- https://apt.releases.hashicorp.com/gpg | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com jammy main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get update && sudo apt-get install terraform packer

echo "Terraform version: $(terraform version | grep ^Terraform)"
echo "Packer version: $(packer version | grep ^Packer)"