output "vm_id" {
  value = module.proxmox_vm.vmid
}

output "vm_name" {
  value = module.proxmox_vm.name
}

output "ssh_user_name" {
  value = module.proxmox_vm.ssh_user
}

output "vm_ip_addresses" {
  value = module.proxmox_vm.vm_ip_addresses
}

output "ssh_commands" {
  value = module.proxmox_vm.ssh_commands
}
