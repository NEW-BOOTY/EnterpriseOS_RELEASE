# Enterprise-OS™ Azure Governance Report (Sample)

Scope:
  - Resource groups assessed using microsoft/sentry/cloud/cloud_integration.sh

Key Findings:
  - 1 storage account allowing TLS versions < 1.2
  - 1 public IP attached to a management VM without a just-in-time policy

Recommended Actions:
  - Enforce TLS 1.2+ on all storage accounts.
  - Apply JIT access policy or move management access behind VPN/Bastion.
