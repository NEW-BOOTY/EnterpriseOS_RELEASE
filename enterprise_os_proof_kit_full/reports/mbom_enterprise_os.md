# Enterprise-OS™ MBOM (Material Bill of Materials)

This MBOM summarizes logical and physical "materials" required to deploy
the Enterprise-OS™ ecosystem.

## 1. Core Nodes

- enterprise_os_root/
  - app/ (Python orchestrator core and modules)
  - modules/ (integration modules for each corporate framework)
  - security/ (PKI, JWT config, RBAC rego)
  - deployment/ (Dockerfile.control-plane, k8s-deployment.yaml, Terraform)

- Enterprise-OS-COGNITIVE-v9/
  - core/ (agents, quantum_crypto, self_healing)
  - cognitive/ (neuro_symbolic and planetary_intel)
  - monetization/ (billing engine)
  - output/ (cognitive_maturity, ethics_matrix)
  - sdk/ (Python SDK)

## 2. Corporate Frameworks

- amazon/aegis/, google/chimera/, meta/clarity/, openai/connect/,
  oracle/veritas/, ibm/orchard/, microsoft/sentry/, apple/synergy/

  Each contributes:
  - cloud/ integrations
  - compliance/ scripts and policies
  - ai/ assist layers
  - os_layer/ or gui/ adapters

## 3. Deployment Substrate

- systemd units in */systemd/*.service
- k8s_manifests/*-deployment.yaml for cluster deployment
- terraform/*/main.tf for cloud provisioning

## 4. Security Controls

- PKI: enterprise_os_root/security/pki
- JWT: enterprise_os_root/security/jwt_config.json
- RBAC: enterprise_os_root/security/rbac_policy.rego
