#!/usr/bin/env bash

echo -e "\n\n **** Install nodejs from nodesource ****"

curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${NODE_MAJOR}.x nodistro main" | \
  sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt-get update && sudo apt-get install nodejs -y

echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
