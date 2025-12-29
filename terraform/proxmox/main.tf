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
  source = "git::https://github.com/kiprotichgidii/proxmox-terraform-module.git//modules/proxmox-vm?ref=main"

  # Provider Variables
  proxmox_api_url  = var.proxmox_api_url
  proxmox_user     = var.proxmox_user
  proxmox_password = var.proxmox_password

  # VM Variables
  node             = "proxmox-pve01"
  vm_name          = "k8snode"
  template_id      = 9003
  vm_count         = 4
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
    ip_address    = "192.168.1.130/24"
    enable_dhcp   = false
    nic           = "enp6s18"
  }
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    vm_names = sort(keys(module.proxmox_vm.vm_ip_addresses))
    vm_ips   = module.proxmox_vm.vm_ip_addresses
    masters  = slice(sort(keys(module.proxmox_vm.vm_ip_addresses)), 0, var.master_count)
    workers  = slice(sort(keys(module.proxmox_vm.vm_ip_addresses)), var.master_count, length(keys(module.proxmox_vm.vm_ip_addresses)))
  })
  filename = "${path.module}/../../ansible/kubespray/inventory/hosts.yml"
}
