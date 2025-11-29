variable "pm_api_url" {
  type        = string
  description = "The API URL, e.g., https://192.168.1.129:8006/api2/json"
}

variable "pm_user" {
  type        = string
  description = "Proxmox User, e.g., root@pam"
}

variable "pm_password" {
  type        = string
  sensitive   = true # Hides value in terminal output
}

variable "pm_tls_insecure" {
  type    = bool
  default = true
}

# --- VM User Secrets ---
variable "ci_user" {
  type    = string
  default = "admin_user"
}

variable "ci_password" {
  type      = string
  sensitive = true
}

variable "ssh_key_file" {
  type        = string
  description = "Path to the public SSH key on your local machine (e.g. ./my_key.pub)"
}