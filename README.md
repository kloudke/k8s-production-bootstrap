# Kubernetes Platform on Proxmox & Libvirt (Terraform + Kubespray)

This repository provides an automated, reproducible way to provision a
production-ready Kubernetes cluster using:

- Terraform (Proxmox / Libvirt)
- Ansible (Kubespray)
- MetalLB, NGINX Ingress, cert-manager, Observability stack

## Architecture

Terraform provisions VM infrastructure.
Ansible (Kubespray) bootstraps Kubernetes.
Helm installs platform components.

## Prerequisites

- Terraform >= 1.5
- Ansible >= 2.14
- Python 3.9+
- Proxmox or Libvirt
- SSH access to all nodes

See `docs/prerequisites.md`

## Repository Structure

See `docs/architecture.md`

## Deployment Workflow

### 1. Provision VMs
```bash
cd terraform/proxmox
terraform init
terraform apply
```