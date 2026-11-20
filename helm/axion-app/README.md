# 🚀 Axion Multi-Environment Helm Chart (`axion-app`)

Yeh Helm Chart poore **Axion Platform** ko Kubernetes (AKS) par multi-environment (Dev, Staging, Prod) me deploy karne ke liye design kiya gaya hai.

---

## 🏗️ Architecture & Components Included

Is Chart me application ke saare microservices aur infrastructure components ek sath parameterized hain:

1. **`axion-ui`**: React/Vite Frontend Application (Service Type `ClusterIP`, Azure Application Gateway Ingress)
2. **`axion-telemetry`**: Telemetry Query Service API (HPA support, Workload Identity, CSI SecretProviderClass)
3. **`axion-ingestion`**: Data Ingestion Service (Azure Key Vault Secrets, PostgreSQL connection)
4. **`axion-simulator`**: IoT Sensor Simulator (Auto-connects to Ingestion Service)
5. **`keyvault` / Workload Identity**: Azure Key Vault CSI SecretProviderClass & ServiceAccount (`axion-keyvault-sa`)
6. **`database` (Optional In-Cluster)**: PostgreSQL aur pgAdmin (agar Azure Flexible Server ki jagah local/test DB chalana ho)

---

## 📁 Directory Structure

```text
helm/axion-app/
├── Chart.yaml                  # Chart metadata (v1.0.0)
├── values.yaml                 # Base / Default configuration
├── values-dev.yaml             # Dev environment overrides
├── values-staging.yaml         # Staging environment overrides
├── values-prod.yaml            # Production environment overrides
├── templates/
│   ├── _helpers.tpl            # Helper templates, common labels, selector labels
│   ├── secrets/
│   │   ├── serviceaccount.yaml         # Workload Identity SA
│   │   └── secretproviderclass.yaml    # Azure Key Vault SecretProviderClass
│   ├── ui/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── ingress.yaml
│   ├── telemetry/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   ├── hpa.yaml
│   │   └── ingress.yaml
│   ├── ingestion/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   ├── simulator/
│   │   ├── deployment.yaml
│   │   └── service.yaml
│   └── database/               # Optional in-cluster DB
│       ├── postgres-deployment.yaml
│       ├── postgres-service.yaml
│       └── pgadmin-deployment.yaml
└── README.md
```

---

## 🌍 Multi-Environment Configuration Differences

| Feature / Setting | DEV (`values-dev.yaml`) | STAGING (`values-staging.yaml`) | PROD (`values-prod.yaml`) |
| :--- | :--- | :--- | :--- |
| **Namespace** | `dev` | `staging` | `prod` |
| **UI Domain** | `dev.axion.b18g151.online` | `staging.axion.b18g151.online` | `axion.b18g151.online` |
| **Telemetry Domain** | `dev-telemetry.b18g151.online`| `staging-telemetry.b18g151.online`| `telemetry.b18g151.online` |
| **UI Replicas** | `1` | `2` | `2` |
| **Telemetry Replicas** | `1` (HPA off) | `2` (HPA: 2-4) | `3` (HPA: 3-10) |
| **Ingestion Replicas** | `1` | `2` | `2` |
| **Data Simulator** | ✅ Enabled (`5s` interval) | ✅ Enabled (`3s` interval) | ❌ Disabled (Real IoT devices) |
| **Azure KeyVault** | `axion-kv-develop` | `axion-kv-staging` | `axion-kv-prod` |
| **Image Tag Policy** | `dev-18` | `staging-rc1` | `v1.0.0` (Semantic Versioning) |
| **Resources** | Low (Economy) | Medium | High (Production SLA) |

---

## ⚡ Deployment Guide (Using Helm CLI)

### 1. Dry Run / Template Test Karein

```powershell
# Dev environment render test
helm template axion-dev ./helm/axion-app -f ./helm/axion-app/values-dev.yaml -n dev

# Prod environment render test
helm template axion-prod ./helm/axion-app -f ./helm/axion-app/values-prod.yaml -n prod
```

### 2. Lint Check

```powershell
helm lint ./helm/axion-app
```

### 3. Deploy to DEV Environment

```powershell
helm upgrade --install axion-dev ./helm/axion-app `
  -f ./helm/axion-app/values-dev.yaml `
  --namespace dev `
  --create-namespace
```

### 4. Deploy to STAGING Environment

```powershell
helm upgrade --install axion-staging ./helm/axion-app `
  -f ./helm/axion-app/values-staging.yaml `
  --namespace staging `
  --create-namespace
```

### 5. Deploy to PROD Environment

```powershell
helm upgrade --install axion-prod ./helm/axion-app `
  -f ./helm/axion-app/values-prod.yaml `
  --namespace prod `
  --create-namespace
```

---

## 🐙 GitOps Deployment with ArgoCD

Agar aap ArgoCD use kar rahe hain to `Axion-Gitops/argocd/` folder me pre-configured Application manifests hain:

1. **Dev Application**:
   ```powershell
   kubectl apply -f ./Axion-Gitops/argocd/application-dev.yaml
   ```

2. **Staging Application**:
   ```powershell
   kubectl apply -f ./Axion-Gitops/argocd/application-staging.yaml
   ```

3. **Prod Application**:
   ```powershell
   kubectl apply -f ./Axion-Gitops/argocd/application-prod.yaml
   ```

4. **Saare Environments Ek Sath (ApplicationSet)**:
   ```powershell
   kubectl apply -f ./Axion-Gitops/argocd/applicationset.yaml
   ```

*(Note: `repoURL` me apna GitHub repository link replace karein).*

---

## ⚙️ Key Overrides (Command-line `--set`)

Kisi bhi service ko quickly enable/disable ya image tag change karne ke liye:

```powershell
# Dev me specific image tag deploy karna:
helm upgrade --install axion-dev ./helm/axion-app `
  -f ./helm/axion-app/values-dev.yaml `
  --set ui.image.tag="dev-19" `
  --namespace dev

# In-cluster PostgreSQL aur pgAdmin test ke liye on karna:
helm upgrade --install axion-dev ./helm/axion-app `
  -f ./helm/axion-app/values-dev.yaml `
  --set database.inCluster.enabled=true `
  --set database.inCluster.pgadmin.enabled=true `
  --namespace dev
```
