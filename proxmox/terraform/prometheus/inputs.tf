variable "pve_api_url" {
  type = string
}

variable "pve_token_id" {
  type = string
}

variable "pve_target_node" {
  type = string
}

variable "pve_cloud_init_storage_pool" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "pve_vm_template" {
  type = string
}

variable "pve_vm_disk_storage_pool" {
  type = string
}

variable "vm_disk_size" {
  type = string
}

variable "data_disk_size" {
  type = string
}

variable "vm_cores" {
  type = string
}

variable "vm_memory" {
  type = string
}

variable "vm_ip_map" {
  type    = string
  default = "192.168.1.152"
}

variable "vm_gateway" {
  type = string
}

variable "vm_nameserver" {
  type = string
}
