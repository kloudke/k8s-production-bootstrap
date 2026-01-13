# Rook Ceph Storage

Rook orchestrates Ceph, a distributed storage system, providing block, object, and file storage for the cluster.

## Deployment
Deployment follows a strict order:
1.  **CRDs**: `kubectl apply -f kubernetes/rook-ceph/crds.yaml`
2.  **Common Resources**: `kubectl apply -f kubernetes/rook-ceph/common.yaml`
3.  **Operator**: `kubectl apply -f kubernetes/rook-ceph/operator.yaml`
4.  **Cluster**: `kubectl apply -f kubernetes/rook-ceph/cluster.yaml`

## Storage Types

### Block Storage (RBD)
Used for `ReadWriteOnce` (RWO) volumes (e.g., Databases).
- **StorageClass**: `rook-ceph-block` (Default)

### Object Storage (S3)
Provides an S3-compatible API.
- **Service**: `rook-ceph-rgw-my-store`
- **Bucket Provisioning**: via ObjectBucketClaims (OBC).

### Shared Filesystem (CephFS)
Used for `ReadWriteMany` (RWX) volumes.
- **StorageClass**: `ceph-filesystem`

## Operations (Toolbox)
To run Ceph commands (like `ceph status`), deploy the toolbox:
```bash
kubectl apply -f kubernetes/rook-ceph/toolbox.yaml
```
Enter the pod:
```bash
kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash
```
Commands:
- `ceph status`: Health check.
- `ceph osd status`: Disk status.
- `ceph df`: Usage stats.
