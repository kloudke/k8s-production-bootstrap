variable "proxmox_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "proxmox_user" {
  description = "Proxmox User"
  type        = string
  default     = "terraform@pve"
}

variable "proxmox_password" {
  description = "Proxmox Password"
  type        = string
  sensitive   = true
}

variable "node" {
  description = "Proxmox Node"
  type        = string
  default     = "proxmox-pve01"
}

variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 3
}

variable "master_count" {
  description = "Number of Control Plane Nodes"
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "k8snode"
}

variable "template_id" {
  description = "VM Template ID"
  type        = number
  default     = 9003
}

variable "ssh_keys" {
  description = "List of SSH public keys to add to the VM"
  type        = list(string)
  default     = []
}
