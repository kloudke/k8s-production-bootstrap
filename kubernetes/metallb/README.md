# MetalLB Load Balancer

MetalLB provides a network load-balancer implementation for Kubernetes clusters that do not run on a supported cloud provider, effectively allowing you to use `type: LoadBalancer` services.

## Deployment

The components are deployed via standard manifests located in `kubernetes/metallb/`.

```bash
kubectl apply -f kubernetes/metallb/metallb.yaml
```

## Configuration

MetalLB is configured in **Layer 2** mode. This means one of the nodes attracts all traffic for the service IP and then spreads it to the pods.

### IP Pool
You must configure an IP address pool that MetalLB controls. These IPs must be **reserved** on your network router so that the router doesn't try to assign them to other devices via DHCP.

**File**: `kubernetes/metallb/ip-pool.yaml`

```yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.220-192.168.1.230 # Change this to your reserved range
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
```

## Verification
Check if the controller and speaker pods are running:
```bash
kubectl get pods -n metallb-system
```
