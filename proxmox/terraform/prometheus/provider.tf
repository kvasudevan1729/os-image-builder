terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.5.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "<azure resource group>"
    storage_account_name = "<azure storage account>"
    container_name       = "<container name>"
    key                  = "prometheus.tf"
  }
}

provider "proxmox" {
  pm_api_url      = var.pve_api_url
  pm_api_token_id = var.pve_token_id
}

provider "azurerm" {
  subscription_id                 = "<subscription id>"
  resource_provider_registrations = "none"
  features {}
}
