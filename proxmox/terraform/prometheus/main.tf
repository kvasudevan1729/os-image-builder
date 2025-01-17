resource "proxmox_vm_qemu" "prometheus" {
  name        = var.vm_name
  desc        = "Prometheus server"
  target_node = var.pve_target_node
  clone       = var.pve_vm_template
  cores       = var.vm_cores
  memory      = var.vm_memory
  onboot      = true
  numa        = true
  hotplug     = "network,disk,usb,cpu,memory"

  agent   = 1
  os_type = "cloud-init"

  disks {
    ide {
      ide3 {
        cloudinit {
          storage = var.pve_cloud_init_storage_pool
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          storage = var.pve_vm_disk_storage_pool
          size    = var.vm_disk_size
        }
      }
      virtio1 {
        disk {
          storage = var.pve_vm_disk_storage_pool
          size    = var.data_disk_size
        }
      }
    }
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # cloud-init settings
  boot       = "order=virtio0"
  ipconfig0  = "ip=${var.vm_ip}/24,gw=${var.vm_gateway}"
  skip_ipv6  = true
  nameserver = var.vm_nameserver

  connection {
    host        = self.default_ipv4_address
    type        = "ssh"
    user        = "ubadmin"
    private_key = file("${path.module}/files/ssh_ubadmin_priv_key")
  }

  provisioner "file" {
    source      = "./files/setup_addl_disk.sh"
    destination = "/tmp/setup_addl_disk.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_addl_disk.sh",
      "/tmp/setup_addl_disk.sh /dev/vdb /data",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl start docker",
    ]
  }
}
