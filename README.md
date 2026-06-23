# OpenList Helm Chart

This chart bootstraps OpenList on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes cluster 1.20+
- Helm v3.2.0+

## Configure OpenList Helm repo

```bash
helm repo add openlist https://openlistteam.github.io/OpenList-Helm
helm repo update
```

## Installing the Chart

Create the namespace `openlist`.

```bash
kubectl create namespace openlist
```

Install the helm chart into the namespace `openlist`.

```bash
helm install openlist openlist/openlist --namespace openlist
```

### Values reference

The default values.yaml should be suitable for most basic deployments.

| Parameter                   | Description                                                                 | Default                 |
|-----------------------------|-----------------------------------------------------------------------------|-------------------------|
| `image.registry`            | Image registry                                                              | `docker.io`             |
| `image.repository`          | Image name                                                                  | `openlistteam/openlist` |
| `image.tag`                 | Image tag                                                                   | `v4.2.2`                |
| `image.pullPolicy`          | Image pull policy                                                           | `IfNotPresent`          |
| `nameOverride`              | Override the chart name                                                     |                         |
| `fullnameOverride`          | Override the full resource name                                             |                         |
| `namespaceOverride`         | Override the namespace for namespaced resources                             |                         |
| `replicaCount`              | Number of OpenList replicas                                                 | `1`                     |
| `updateStrategy`            | Deployment update strategy. Use `Recreate` with RWO volumes; `RollingUpdate` requires RWX volumes | `{type: Recreate}` |
| `admin.password`            | Initial admin password. Used only when OpenList creates the admin user       |                         |
| `admin.existingSecret`      | Existing Secret containing key `OPENLIST_ADMIN_PASSWORD`                    |                         |
| `timezone`                  | Value for the `TZ` environment variable                                     | `UTC`                   |
| `umask`                     | Value for the `UMASK` environment variable                                  | `022`                   |
| `podAnnotations`            | Additional pod annotations                                                  | `{}`                    |
| `podLabels`                 | Additional pod labels                                                       | `{}`                    |
| `extraEnv`                  | Additional container environment variables                                  | `[]`                    |
| `resources`                 | Container resource requests and limits                                      | `{}`                    |
| `livenessProbe`             | Container liveness probe configuration                                      | `{}`                    |
| `readinessProbe`            | Container readiness probe configuration                                     | `{}`                    |
| `nodeSelector`              | Pod node selector                                                           | `{}`                    |
| `tolerations`               | Pod tolerations                                                             | `[]`                    |
| `affinity`                  | Pod affinity                                                                | `{}`                    |
| `persistence.storageClass`  | Specify the storageClass used to provision the volume                       |                         |
| `persistence.accessMode`    | The access mode of the volume                                               | `ReadWriteOnce`         |
| `persistence.size`          | The size of the volume                                                      | `5Gi`                   |
| `storage.enabled`           | Enable a separate PVC for OpenList Local driver file storage                 | `false`                 |
| `storage.mountPath`         | Container path where the file storage PVC is mounted                         | `/storage`              |
| `storage.existingClaim`     | Existing PVC to mount as file storage instead of creating one                |                         |
| `storage.storageClass`      | Specify the storageClass used to provision the file storage volume           |                         |
| `storage.accessMode`        | The access mode of the file storage volume                                  | `ReadWriteOnce`         |
| `storage.size`              | The size of the file storage volume                                         | `100Gi`                 |
| `service.type`              | Kubernetes service type                                                     | `ClusterIP`             |
| `service.annotations`       | Additional service annotations                                              | `{}`                    |
| `service.labels`            | Additional service labels                                                   | `{}`                    |
| `service.loadBalancerIP`    | Kubernetes service loadBalancerIP                                           |                         |
| `service.http.port`         | Kubernetes service http port                                                | `5244`                  |
| `service.http.targetPort`   | Kubernetes service http targetPort                                          | `5244`                  |
| `service.http.nodePort`     | Kubernetes service http nodePort (valid only when `service.type=NodePort`)  | `35244`                 |
| `service.https.enabled`     | Enable the https service port                                               | `true`                  |
| `service.https.port`        | Kubernetes service https port                                               | `5245`                  |
| `service.https.targetPort`  | Kubernetes service https targetPort                                         | `5245`                  |
| `service.https.nodePort`    | Kubernetes service https nodePort (valid only when `service.type=NodePort`) | `35245`                 |
| `httpRoute.enabled`         | Enable Gateway API HTTPRoute                                                | `false`                 |
| `httpRoute.annotations`     | Additional HTTPRoute annotations                                            | `{}`                    |
| `httpRoute.labels`          | Additional HTTPRoute labels                                                 | `{}`                    |
| `httpRoute.parentRefs`      | Gateway API parent references                                               | `[]`                    |
| `httpRoute.hostnames`       | HTTPRoute hostnames                                                         | `[]`                    |
| `httpRoute.rules`           | HTTPRoute rules. Defaults to routing `/` to the HTTP service port           | `[]`                    |

If your Kubernetes cluster does not have a default StorageClass configured, please specify one explicitly.
For example:

```bash
helm install openlist openlist/openlist --namespace openlist --set persistence.storageClass=longhorn
```

### Gateway API HTTPRoute

Enable `httpRoute` to expose OpenList through a Gateway API implementation:

```yaml
httpRoute:
  enabled: true
  parentRefs:
    - name: envoy-gateway
      namespace: envoy-gateway
  hostnames:
    - openlist.example.com
```

When `httpRoute.rules` is empty, the chart creates a `PathPrefix` `/` rule that forwards traffic to the OpenList HTTP service port.

### Local file storage

The `persistence` volume is mounted at `/opt/openlist/data` for OpenList application data such as config, database, and logs. Do not use it as a Local driver root.

Enable `storage` to mount a separate PVC for files:

```yaml
storage:
  enabled: true
  mountPath: /storage
  size: 100Gi
```

Then configure the OpenList Local driver with root folder path `/storage`.

## Uninstallation

To uninstall/delete the openlist deployment:

```bash
helm uninstall openlist --namespace openlist
kubectl delete namespace openlist
```

## Set the admin's password

You can **randomly generate** or **manually set**

```bash
# Randomly generate password
kubectl exec -n openlist $(kubectl get po -n openlist -l app=openlist | awk 'NR==2{print $1}') -- ./openlist admin random

# Manually set password to `NEW_PASSWORD` (replace this)
kubectl exec -n openlist $(kubectl get po -n openlist -l app=openlist | awk 'NR==2{print $1}') -- ./openlist admin set NEW_PASSWORD
```
