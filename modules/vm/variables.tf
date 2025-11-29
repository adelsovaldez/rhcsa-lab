variable "vm_name" {}
variable "vm_cpu" {}
variable "vm_memory" {}
variable "vm_disk_size" {} 
variable "vm_storage" {}
variable "template_name" {}
variable "ci_user" {}
variable "ci_password" {}
variable "ssh_public_key" {} # Accepts the key string
variable "vm_ip" {}
variable "vm_gateway" {}

variable "network_bridge" {
  default = "vmbr0"
}