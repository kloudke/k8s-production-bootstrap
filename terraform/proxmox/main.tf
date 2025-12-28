# Terraform Provider Versions
terraform {
  required_version = ">= 1.10.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "= 3.0.2-rc06"
    }
  }
}

# Proxmox VM Resource
module "proxmox_vm" {
  #source = "./modules/proxmox-vm"
  source = "git::https://github.com/kiprotichgidii/proxmox-terraform-module.git//modules/proxmox-vm?ref=main"

  # Provider Variables
  proxmox_api_url  = var.proxmox_api_url
  proxmox_user     = var.proxmox_user
  proxmox_password = var.proxmox_password

  # VM Variables
  vm_count    = var.vm_count
  vm_name     = var.vm_name_prefix
  node        = var.node
  template_id = var.template_id

  # Standard Config
  cpu_cores        = 2
  cpu_sockets      = 1
  memory           = 4096
  boot_order       = "order=scsi0;ide2;net0"
  clone            = true
  storage_pool     = "local-lvm"
  iso_storage_pool = "local"

  disks = [
    {
      size    = "100G"
      storage = "nvme-storage"
      type    = "disk"
      slot    = "scsi0"
      format  = "qcow2"
    }
  ]
  networks = [
    {
      id     = "0"
      bridge = "vmbr0"
      model  = "virtio"
    }
  ]
  cloudinit = {
    user_fullname = "Gedion Kiprotich"
    timezone      = "Africa/Nairobi"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    vm_names = module.proxmox_vm.name
    vm_ips   = module.proxmox_vm.vm_ip_addresses
  })
  filename = "${path.module}/../../ansible/inventory/hosts.yml"
}
