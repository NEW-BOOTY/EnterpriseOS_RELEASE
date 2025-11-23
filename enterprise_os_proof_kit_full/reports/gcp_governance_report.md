# Enterprise-OS™ GCP Governance Report (Sample)

Scope:
  - Projects scanned via google/chimera/cloud/cloud_integration.sh

Key Findings:
  - 2 projects missing mandatory labels (owner, environment)
  - 1 firewall rule allowing 0.0.0.0/0 on a non-standard port

Recommended Actions:
  - Enforce label policies across all projects.
  - Replace broad firewall rules with service-specific, IP-restricted rules.
