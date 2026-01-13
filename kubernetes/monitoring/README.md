# Monitoring (Prometheus Stack)

We use the **kube-prometheus-stack** Helm chart, which includes:
- **Prometheus**: Metrics collection.
- **Alertmanager**: Alert handling.
- **Grafana**: Visualization.
- **Node Exporter**: Hardware metrics.

## Deployment
Using Helm (v9.3.0+):
```bash
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  -f kubernetes/monitoring/values.yaml
```

## Configuration
Values are customized in `kubernetes/monitoring/values.yaml`:
- **Persistence**: Enabled using `rook-ceph-block` StorageClass.
- **Ingress**: Configured for `grafana.<DOMAIN>`.
- **Retention**: Metrics retention period (default 10d).

## Accessing Grafana
Access via the configured Ingress hostname (e.g., `https://grafana.cloudspinx.dpdns.org`).
- **Default User**: `admin`
- **Password**: Defined in `values.yaml` (`adminPassword`) or auto-generated.
