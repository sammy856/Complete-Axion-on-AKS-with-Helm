# ArgoCD Installation & Access Guide

## Why a Single Pod YAML Fails for ArgoCD
ArgoCD is not just an API server; it is a full GitOps controller consisting of multiple cooperating microservices:
1. `argocd-server` (UI & API Server)
2. `argocd-repo-server` (Clones Git repos and renders manifests)
3. `argocd-application-controller` (Reconciliation engine)
4. `argocd-redis` (Session cache & state storage)
5. `argocd-dex-server` (OIDC / authentication)
6. CRDs & RBAC (`Application`, `AppProject`, ClusterRoles, ServiceAccounts)

Running only `argocd-server` in `default` namespace without RBAC results in permission errors (`configmaps is forbidden`, `secrets is forbidden`) and crash/failure to connect.

---

## Standard Installation

```powershell
# 1. Create namespace
kubectl create namespace argocd

# 2. Apply official ArgoCD manifests (Server-Side apply avoids CRD size limits)
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

---

## Port Forwarding

```powershell
kubectl port-forward svc/argocd-server -n argocd 8080:443
# OR if using port 11111:
kubectl port-forward svc/argocd-server -n argocd 11111:443
```

URL: [https://localhost:8080](https://localhost:8080) (or `https://localhost:11111`)

---

## Admin Credentials

- **Username**: `admin`
- **Password**: `admin12345`

