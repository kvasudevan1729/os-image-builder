#!/usr/bin/env bash

set -eu -o pipefail
disk_device="${1}"
mount_point="${2}"

echo "=> setting up disk ${disk_device} as ${mount_point} ..."
sudo mkdir -p ${mount_point}
sudo mkfs.ext4 ${disk_device}
echo "${disk_device} ${mount_point}            ext4    defaults        0       2" | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mount /data
sudo chown -R ubadmin:ubadmin /data

echo "=> list of block devices ..."
lsblk -f

