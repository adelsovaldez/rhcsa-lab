terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6" # V3 Release Candidate
    }
  }
}

provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_password     = var.pm_password
  pm_tls_insecure = var.pm_tls_insecure
}

module "vm" {
  source = "./modules/vm"

  # VM Specs
  vm_name      = "rhel9-vm-server-01"
  vm_cpu       = 2
  vm_memory    = 4096
  vm_disk_size = 20
  vm_storage   = "local-lvm"

  # Template Name
  template_name = "rhel9-base"

  # Cloud-Init & Secrets
  ci_user        = var.ci_user
  ci_password    = var.ci_password
  
  # Reads the key from the file path defined in variables
  ssh_public_key = file(var.ssh_key_file)

  # Network Settings
  vm_ip      = "192.168.1.150"
  vm_gateway = "192.168.1.1"
}