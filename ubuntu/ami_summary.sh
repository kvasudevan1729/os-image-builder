#!/bin/bash

echo -e "\n\n **** METADATA **** \n"

echo "OS Kernel: $(uname -r)"
echo "openssl: $(openssl version)"
echo "aws: $(aws --version)"
echo "git: $(git --version)"
echo "jq: $(jq --version)"
echo "python: $(python -V)"
echo "snyk: $(snyk --version)"
echo "terraform: $(terraform --version | head -1)"
echo "packer: $(packer --version)"
echo "kubectl: $(kubectl version --output=json 2>/dev/null | jq -r '.clientVersion.gitVersion')"
echo "lynis: $(lynis --version)"
echo "node: $(node --version)"
echo "npm: $(npm --version)"

echo -e "\n****************\n"
