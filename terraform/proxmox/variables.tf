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

variable "vm_name_prefix" {
  description = "Prefix for VM names"
  type        = string
  default     = "k8s-node"
}

variable "template_id" {
  description = "VM Template ID"
  type        = number
  default     = 9003
}

variable "ssh_public_key" {
  description = "SSH Public Key for Cloud-Init"
  type        = string
  default     = ""
}
