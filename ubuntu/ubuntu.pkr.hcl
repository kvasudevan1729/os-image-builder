packer {
  required_plugins {
    amazon = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "base_ami_id" {
  type    = string
}

variable "ami_build_no" {
  type    = string
  default = "1.0.0"
}

variable "aws_profile" {
  type    = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "subnet_id" {
  type    = string
}

variable "security_group_id" {
  type    = string
}

variable "ssh_keypair_name" {
  type    = string
}

variable "ssh_private_key_file" {
  type    = string
}

variable "kubectl_version" {
  type    = string
}

source "amazon-ebs" "ubuntu-base" {
  ami_name                    = "ubuntu-ami-${var.ami_build_no}"
  instance_type               = "t2.small"
  source_ami                  = var.base_ami_id
  ssh_username                = "ubuntu"
  ssh_interface               = "private_ip"
  associate_public_ip_address = false
  ami_virtualization_type     = "hvm"
  subnet_id                   = var.subnet_id
  security_group_ids   = [ var.security_group_id ]
  ssh_keypair_name     = var.ssh_keypair_name
  ssh_private_key_file = var.ssh_private_key_file

  # uncomment to additional devices
  #launch_block_device_mappings {
  #  device_name = "/dev/sda1"
  #  volume_size = "10"
  #  volume_type = "gp2"
  #  delete_on_termination = true
  #}

  tags = {
    Version = var.ami_build_no
    OS_Version    = "Ubuntu"
    Base_AMI_Name = "{{ .SourceAMIName }}"
   }

  profile = var.aws_profile
  region  = var.aws_region
}

build {
  name    = "ubuntu-ami-build"
  sources = [
    "source.amazon-ebs.ubuntu-base"
  ]

  provisioner "shell" {
    inline = [
      "echo -e '=== APT SETUP ==='",
      "echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections",
      "sudo dpkg --configure -a",
      "sudo apt-get update -y",
      "sudo apt-get -u dist-upgrade -y",
      "sudo apt-get autoremove -y",
      "echo '============'",
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '=== BASE TOOLS ==='",
      "sudo apt-get -y install gnupg software-properties-common",
      "sudo add-apt-repository -y ppa:deadsnakes/ppa",
      "sudo apt-get upgrade python3 python3-pip -y",
      "sudo ln -s /usr/bin/python3 /usr/bin/python",
      "sudo apt-get install curl ca-certificates gnupg git tcpdump net-tools unzip -y",
      "sudo apt-get install jq -y",
      "sudo snap install aws-cli --classic",
      "echo '============'",
    ]
  }

  # install application tools
  provisioner "shell" {
    script = "setup_hashicorp_tools.sh"
  }

  provisioner "shell" {
    script = "setup_nodejs.sh"
  }

  provisioner "shell" {
    script = "setup_kubectl.sh"
    environment_vars = [
      "kubectl_version=${var.kubectl_version}",
    ]
  }

  provisioner "shell" {
    script = "setup_helm.sh"
  }

  # install security tools
  provisioner "shell" {
    inline = [
      "sudo apt-get install lynis -y"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo '=> installing snyk ...'",
      "sudo npm install snyk -g",
    ]
  }

  provisioner "shell" {
    script = "ami_summary.sh"
  }
}
