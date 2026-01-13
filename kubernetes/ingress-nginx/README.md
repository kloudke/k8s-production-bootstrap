# NGINX Ingress Controller

The NGINX Ingress Controller handles inbound connections to the cluster, providing HTTP/HTTPS load balancing and SSL termination.

## Deployment
It is deployed using manifests (generated from Helm) located in `kubernetes/ingress-nginx/`.

```bash
kubectl apply -f kubernetes/ingress-nginx/
```

## Architecture
- **Service Type**: `LoadBalancer`. It requests an IP from **MetalLB**.
- **Replica Count**: 2 (High Availability).
- **Ingress Class**: `nginx`.

## Configuration
The controller is configured to:
- Force SSL Redirection (`force-ssl-redirect: "true"` annotation commonly used).
- Report its status using the Publish Service arguments (specifically configured to ensure correct IP reporting).

## Verification
Get the External IP of the Ingress Controller:
```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller
```
It should have an `EXTERNAL-IP` from your MetalLB pool (e.g., `192.168.1.220`).

### Troubleshooting
If Ingress resources show an internal Node IP instead of the LoadBalancer IP, ensure the controller args include:
```yaml
- --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
```
