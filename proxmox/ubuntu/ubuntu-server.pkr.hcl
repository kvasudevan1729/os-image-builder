# Packer Template to create an Ubuntu Server on Proxmox

source "proxmox-iso" "ubuntu-server" {

  # Proxmox Connection Settings
  proxmox_url = "${var.proxmox_api_url}"
  username    = "${var.proxmox_api_token_id}"
  token       = "${var.proxmox_api_token_secret}"

  # VM General Settings
  node                 = "${var.proxmox_node}"
  vm_name              = "ubuntu-tmpl"
  template_description = "Ubuntu Noble with docker and other ops tools"
  os                   = "l26"

  # VM OS Settings
  boot_iso {
    type         = "ide"
    iso_file     = "iso-images:iso/ubuntu-24.04.1-live-server-amd64.iso"
    unmount      = true
    iso_checksum = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  }

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size    = "20G"
    storage_pool = "${var.proxmox_vm_storage_pool}"
    type         = "virtio"
    format       = "raw"
  }

  # VM CPU Settings
  cores = "2"

  # VM Memory Settings
  memory = "2048"

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }

  # PACKER Boot Commands
  boot_command = [
    "c<enter>",
    "linux /casper/vmlinuz --- autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/'",
    "<enter><wait><wait>",
    "initrd /casper/initrd",
    "<enter><wait><wait>",
    "boot<enter>"
  ]
  boot_wait = "10s"

  # PACKER Autoinstall Settings
  http_directory = "http"
  # (Optional) Bind IP Address and Port
  # http_bind_address = "0.0.0.0"
  http_port_min = 8801
  http_port_max = 8805

  ssh_username         = "ubadmin"
  ssh_private_key_file = "./files/pkr_ssh_key"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "20m"
}

# Build Definition to create the VM Template
build {
  name    = "ubuntu-server"
  sources = ["source.proxmox-iso.ubuntu-server"]

  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt-get -y autoremove --purge",
      "sudo apt-get -y clean",
      "sudo apt-get -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo sync"
    ]
  }

  # remove loopback from debian template - useful when terraform provisioning
  provisioner "shell" {
    inline = [
      "sudo sed -i '/^127.0.1.1/d' /etc/cloud/templates/hosts.debian.tmpl"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'datasource_list: [ConfigDrive, NoCloud]' | sudo tee /etc/cloud/cloud.cfg.d/99-pve.cfg"
    ]
  }

  # setup any ops tools needed here
  provisioner "shell" {
    script = "./files/setup_tools.sh"
  }
}
