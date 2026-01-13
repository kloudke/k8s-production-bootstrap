# Cert-Manager

Cert-Manager automates the management and issuance of TLS certificates from various issuing sources, primarily Let's Encrypt.

## Deployment
```bash
kubectl apply -f kubernetes/cert-manager/cert-manager.yaml
```

## Configuration

### Cloudflare API Token
If using DNS-01 validation (required for wildcard certificates or internal networks), you must provide a Cloudflare API Token.

```bash
kubectl create secret generic cloudflare-apitoken-secret \
  --namespace cert-manager \
  --from-literal=apitoken='<YOUR_TOKEN>' \
  --dry-run=client -o yaml | kubectl apply -f -
```

### ClusterIssuers
We define cluster-wide issuers in `kubernetes/cert-manager/cluster-issuers.yaml`.
- `letsencrypt-staging`: For testing (higher rate limits).
- `letsencrypt-prod`: For production certificates.

To use an issuer, add an annotation to your Ingress:
```yaml
annotations:
  cert-manager.io/cluster-issuer: "letsencrypt-prod"
```
