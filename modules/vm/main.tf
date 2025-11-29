terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
}

resource "proxmox_vm_qemu" "vm-rhel9" {
  count       = 3 # Creates 3 VMs with incremental IPs
  target_node = "proxmox"
  vmid        = 0
  name        = count.index == 0 ? var.vm_name : "${var.vm_name}-${count.index}"
  desc        = "Terraform Managed"
  clone       = var.template_name
  full_clone  = true
  os_type     = "cloud-init"
  bios        = "seabios"
  memory      = var.vm_memory
  scsihw      = "virtio-scsi-pci"

  # Boot from the OS disk
  boot     = "order=virtio0"
  agent    = 1 # QEMU Guest Agent
  cores    = var.vm_cpu
  sockets  = 1
  cpu_type = "host"

  # --- DISK 1: The OS Drive ---
  disk {
    slot     = "virtio0"
    type     = "disk"
    size     = "${var.vm_disk_size}G"
    storage  = var.vm_storage
    iothread = true
  }

  # --- DISK 2: The Cloud-Init Drive ---
  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.vm_storage
  }

  # Cloud-Init Config
  ciuser     = var.ci_user
  cipassword = var.ci_password
  sshkeys    = var.ssh_public_key # Injects the key

  # Handles IP increments if you scale up (.150, .151)
  ipconfig0 = "ip=192.168.1.${150 + count.index}/24,gw=${var.vm_gateway}"

  # Network
  network {
    id     = 0
    model  = "virtio"
    bridge = var.network_bridge
  }
}