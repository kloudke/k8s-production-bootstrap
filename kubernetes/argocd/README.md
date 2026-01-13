# ArgoCD (GitOps)

ArgoCD is a declarative, GitOps continuous delivery tool for Kubernetes.

## Deployment
Using Helm:
```bash
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  -f kubernetes/argocd/values.yaml
```

## Configuration
Configured in `kubernetes/argocd/values.yaml`:
- **Ingress**: Exposed on `argocd.<DOMAIN>`.
- **SSL**: Termination handled by Nginx Ingress (ArgoCD runs in insecure mode internally).
- **Global Domain**: `global.domain` set to match the ingress host.

## Accessing UI
Access via `https://argocd.cloudspinx.dpdns.org`.
- **Username**: `admin`
- **Password**: The initial password is the name of the ArgoCD server pod.
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
  ```

## App of Apps
You can configure ArgoCD to watch this repository and automatically sync applications defined in `kubernetes/argocd/applications/` (if configured).
