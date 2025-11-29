# Automated RHCSA Lab Environment

This repository contains **Infrastructure as Code (IaC)** using [Terraform](https://www.terraform.io/) to automatically provision **Red Hat Enterprise Linux 9 (RHEL 9)** virtual machines on a **Proxmox VE** server.

This project was built to create a disposable, consistent lab environment for studying for the **Red Hat Certified System Administrator (RHCSA)** exam.

## 🚀 Features

* **Automated Deployment:** Deploys RHEL 9 VMs in under a minute.
* **Golden Image Cloning:** Uses a sanitized Proxmox template with Cloud-Init.
* **Infrastructure Management:**
    * Configures CPU, RAM, and Storage resizing (20GB).
    * Sets Static IP addresses automatically.
    * Injects SSH keys for password-less login.
* **Scalable:** Can easily scale from 1 to N servers by changing a single variable.
* **Secure:** Secrets (Passwords, Keys, API Tokens) are completely separated from the code.

## 📋 Prerequisites

Before running this code, you need:

1.  **Proxmox VE** (Version 7.x or 8.x).
2.  **Terraform** installed on your local machine.
3.  **A RHEL 9 "Golden Image" Template** existing in Proxmox (see instructions below).
4.  **SSH Key Pair** generated locally (`ssh-keygen -t rsa -f my_key`).

## 🛠️ Setting up the Golden Image (One-Time Setup)

This Terraform code relies on a template named `rhel9-base`. You must create this manually once in Proxmox:

1.  Create a VM with **RHEL 9 ISO**.
2.  Install the OS (Minimal Install recommended).
3.  Install required packages:
    ```bash
    dnf install -y qemu-guest-agent cloud-init
    systemctl enable qemu-guest-agent
    ```
4.  **Sanitize the VM** (Crucial for Cloud-Init to run on clones):
    ```bash
    # Reset Machine ID
    truncate -s 0 /etc/machine-id
    rm /var/lib/dbus/machine-id
    ln -s /etc/machine-id /var/lib/dbus/machine-id

    # Remove SSH keys and History
    rm -f /etc/ssh/ssh_host_*
    history -c
    poweroff
    ```
5.  In Proxmox Hardware settings:
    * **Remove** the CD-ROM drive.
    * **Add** a Cloud-Init Drive (IDE bus).
6.  Right-click the VM -> **Convert to Template**.
7.  Ensure the template is named **`rhel9-base`**.

## ⚙️ Installation & Configuration

1.  **Clone this repository:**
    ```bash
    git clone [https://github.com/adelsovaldez/rhcsa-lab.git](https://github.com/adelsovaldez/rhcsa-lab.git)
    cd rhcsa-lab
    ```

2.  **Generate an SSH Key (if you haven't already):**
    ```bash
    ssh-keygen -t rsa -f my_key
    ```
    *Note: Do not enter a passphrase for lab automation purposes.*

3.  **Create your Secrets file:**
    Create a file named `terraform.tfvars` in the root folder. This file is ignored by Git. Paste the following and fill in your details:

    ```hcl
    # Proxmox Connection
    pm_api_url      = "https://<YOUR_PROXMOX_IP>:8006/api2/json"
    pm_user         = "root@pam"
    pm_password     = "YOUR_PROXMOX_PASSWORD"
    pm_tls_insecure = true

    # VM Configuration
    ci_password     = "StrongPassword123!" # Password for the VM user
    ssh_key_file    = "./my_key.pub"       # Path to the key generated in step 2
    ```

## ▶️ Usage

1.  **Initialize Terraform:**
    Downloads the required Proxmox provider plugins.
    ```bash
    terraform init
    ```

2.  **Review the Plan:**
    Shows you what resources will be created.
    ```bash
    terraform plan
    ```

3.  **Apply / Build:**
    Creates the VMs.
    ```bash
    terraform apply
    # Type 'yes' when prompted
    ```

4.  **Access the VM:**
    Once finished, SSH into the new server:
    ```bash
    ssh -i my_key admin_user@192.168.1.150
    ```

## 📂 Project Structure

```text
.
├── modules/
│   └── vm/             # The logic for creating a single VM
│       ├── main.tf
│       └── variables.tf
├── main.tf             # Root configuration (Provider & Module call)
├── variables.tf        # Root variable definitions
├── terraform.tfvars    # (Excluded) Your secrets & local config
└── README.md           # Documentation