# Enterprise-OS™ AWS Governance Report (Sample)

Scope:
  - Accounts onboarded via google/chimera/cloud/cloud_integration.sh
  - IAM, networking, storage, and CI/CD components in scope.

Key Findings:
  - 1 admin-equivalent role without MFA restriction (high)
  - 3 security groups with overly broad ingress rules on non-HTTP ports (medium)
  - 0 S3 buckets with public write or read permissions (pass)

Recommended Actions:
  - Restrict admin-equivalent role to require MFA sessions.
  - Tighten SG ingress to least-privilege CIDR ranges.
  - Maintain continuous posture checking via Enterprise-OS orchestrator.
