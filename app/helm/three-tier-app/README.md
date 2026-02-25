# three-tier-app Helm Chart

Deploys a simple 3-tier app on Kubernetes:
- Frontend: React served by Nginx
- Backend: Flask API
- Database: PostgreSQL (optional, enabled by default)

## Install

```bash
helm upgrade --install three-tier-app ./app/helm/three-tier-app --namespace three-tier-app --create-namespace
```

## Access

```bash
kubectl -n three-tier-app port-forward svc/three-tier-app-frontend 8080:80
```

Open `http://localhost:8080`.

## GitLab CI variables for deploy

Set these CI/CD variables in GitLab:

- `KUBE_CONFIG`: base64-encoded kubeconfig (optional if runner already has kubectl context)
- `DB_PASSWORD`: database password for app secret
- `CI_REGISTRY_USER` and `CI_REGISTRY_PASSWORD`: used for image push and pull secret creation
