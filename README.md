# Kubernetes Production Bootstrap

An automated, reproducible, and production-ready Kubernetes platform built on Proxmox.

This project automates the entire lifecycle of a Kubernetes cluster:
1.  **Infrastructure as Code**: Terraform provisions virtual machines on Proxmox/Libvirt.
2.  **Configuration Management**: Ansible (Kubespray) bootstraps the Kubernetes cluster.
3.  **GitOps & Components**: Helm and ArgoCD deploy core platform services (Storage, Networking, Observability).

## 🏗️ Architecture

The platform is designed for high availability and robust operations.

| Layer | Technology | Details |
|-------|------------|---------|
| **Infrastructure** | **Terraform** + **Proxmox** | VMs with specific roles (Control Plane, Workers). Cloud-Init for initial setup. |
| **OS** | **Ubuntu** | Automated OS tuning via Ansible. |
| **Orchestration** | **Kubespray (Ansible)** | Deploys HA Kubernetes, Containerd, Calico CNI. |
| **Storage** | **Rook Ceph** | Hyper-converged storage. Provides **Block (RBD)** and **Object (S3)** storage. |
| **Networking** | **MetalLB** + **Nginx Ingress** | Layer 2 LoadBalancing and Ingress Management with SSL termination. |
| **Certificate** | **Cert-Manager** | Automated TLS certificates via Let's Encrypt (DNS-01/HTTP-01). |
| **Observability** | **Prometheus Stack** + **Loki** | Metrics (Grafana) and Logs aggregation. |
| **GitOps** | **ArgoCD** | Declarative management of applications. |

---

## 📋 Prerequisites

### Tools
Ensure you have the following installed on your control machine:
*   [Terraform](https://www.terraform.io/) (>= 1.5)
*   [Ansible](https://www.ansible.com/) (>= 2.14)
*   [Python](https://www.python.org/) (3.9+)
*   `kubectl` and `helm`

### Environment
*   **Proxmox VE Cluster**: Accessible API and user credentials.
*   **Cloud-Init Template**: A standard Ubuntu cloud image template created in Proxmox.
*   **SSH Keys**: An SSH key pair for accessing the nodes (`~/.ssh/id_rsa`).
*   **DNS**: A domain name managed (e.g., via Cloudflare) for Let's Encrypt DNS-01 challenges.

---

## 🚀 Deployment Guide

### Phase 1: Infrastructure Provisioning (Terraform)

Provision the virtual machines on Proxmox.

1.  **Configure Credentails**:
    Update `terraform/proxmox/terraform.tfvars` with your Proxmox credentials and cluster settings.
    ```hcl
    proxmox_api_url = "https://<PROXMOX_IP>:8006/api2/json"
    proxmox_user    = "root@pam"
    ssh_keys        = "ssh-rsa AAAA..."
    ```

2.  **Apply Terraform**:
    ```bash
    cd terraform/proxmox
    terraform init
    terraform plan
    terraform apply --auto-approve
    ```
    *This will create the VMs (e.g., `k8s-cp-1`, `k8s-worker-1`) and generate an Ansible inventory.*

### Phase 2: Kubernetes Bootstrap (Ansible)

Bootstrap the Kubernetes cluster using Kubespray.

1.  **Check Inventory**:
    Ensure `ansible/inventory/hosts.yml` was generated correctly by Terraform.

2.  **Run Playbook**:
    ```bash
    cd ansible
    ansible-playbook -i inventory/hosts.yml -u ubuntu --private-key ~/.ssh/id_rsa cluster.yml
    ```
    *(This process can take 10-20 minutes)*

3.  **Fetch Kubeconfig**:
    ```bash
    ansible-playbook -i inventory/hosts.yml --private-key ~/.ssh/id_rsa fetch-kubeconfig.yml
    ```
    *Configuration saved to `ansible/inventory/artifacts/admin.conf`.*

### Phase 3: Platform Components

Deploy essential services. The repository includes a helper workflow/scripts.

1.  **Export Kubeconfig**:
    ```bash
    export KUBECONFIG=$(pwd)/ansible/inventory/artifacts/admin.conf
    ```

2.  **Deploy Components**:
    You can manually apply manifests or use the provided GitHub Action workflow.

    *   **MetalLB**:
        ```bash
        kubectl apply -f kubernetes/metallb/
        ```
    *   **Ingress Nginx**:
        ```bash
        kubectl apply -f kubernetes/ingress-nginx/
        ```
    *   **Rook Ceph** (Storage):
        ```bash
        kubectl apply -f kubernetes/rook-ceph/crds.yaml
        kubectl apply -f kubernetes/rook-ceph/common.yaml
        kubectl apply -f kubernetes/rook-ceph/operator.yaml
        kubectl apply -f kubernetes/rook-ceph/cluster.yaml
        ```
    *   **Cert-Manager**:
        ```bash
        kubectl apply -f kubernetes/cert-manager/
        ```

3.  **Deploy Observability & GitOps**:
    *   **Monitoring**:
        ```bash
        helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitoring -f kubernetes/monitoring/values.yaml
        ```
    *   **ArgoCD**:
        ```bash
        helm upgrade --install argocd argo/argo-cd -n argocd -f kubernetes/argocd/values.yaml
        ```

---

## 🧩 Component Configuration

### Networking (MetalLB & Ingress)
*   **MetalLB**: Configured in Layer 2 mode. Updates `ip-pool.yaml` with your LAN's reserved IP range.
*   **Ingress**: Nginx Controller is exposed via MetalLB. `force-ssl-redirect` is enabled.

### Storage (Rook Ceph)
*   **Devices**: Automatically consumes unused disks on worker nodes.
*   **StorageClasses**:
    *   `rook-ceph-block`: (Default) RWO Block storage.
    *   `ceph-bucket`: Object storage (S3 compatible).
    *   `ceph-filesystem`: RWX Shared filesystem.

### Automation (ArgoCD)
*   ArgoCD is deployed with a custom `values.yaml` enabling Ingress on `argocd.<DOMAIN>`.
*   Connects to this repository to manage "App of Apps".

---

## 🛠️ Operations

### Accessing the Cluster
```bash
kubectl get nodes -o wide
```

### Upgrades
*   **Kubernetes**: update `kubespray_version` in Ansible config and re-run `upgrade-cluster.yml`.
*   **VMs**: Update Terraform count/specs and apply. *Caution: This may recreate VMs.*

---

## 🐞 Troubleshooting

*   **Ingress Webhook Failures**: If the Ingress Admission Webhook fails (e.g., `connection refused`), typically the controller pod is restarting. Retry after availability.
*   **Ceph OSDs**: Use the `rook-ceph-tools` pod to debug OSD status: `ceph status`.
