#!/bin/bash

set -eu

echo -e "\n\n **** install kubectl (${kubectl_version}) ****"

v_version="v${kubectl_version}"
base_url="https://dl.k8s.io/release"

kubectl_url="${base_url}/${v_version}/bin/linux/amd64/kubectl"
curl -L -o /tmp/kubectl ${kubectl_url}

echo "=> get checksum file"
curl -LO "${base_url}/v${kubectl_version}/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  /tmp/kubectl" | sha256sum --check

chmod +x /tmp/kubectl
sudo mv /tmp/kubectl /usr/local/bin/kubectl
