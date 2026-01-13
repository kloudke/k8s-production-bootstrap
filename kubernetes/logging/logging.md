# Logging (Loki Stack)

We use the **Loki Stack** (Loki + Promtail) for log aggregation.
- **Promtail**: Agent on every node that ships logs to Loki.
- **Loki**: Datastore for logs.

## Deployment
Using Helm:
```bash
helm upgrade --install loki-stack grafana/loki-stack \
  --namespace logging \
  --create-namespace \
  -f kubernetes/logging/values.yaml
```

## Configuration
Configured in `kubernetes/logging/values.yaml`.
- **Persistence**: Enabled for Loki to persist logs across restarts using `rook-ceph-block`.

## Accessing Logs
Logs are viewed through **Grafana**.
1.  Go to Grafana -> **Explore**.
2.  Select **Loki** as the data source.
3.  Query logs (e.g., `{namespace="default"}`).
