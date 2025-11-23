# Enterprise-OS™ Security Model

Key security features:

- Zero telemetry by default: no outbound analytics or tracking calls.
- PKI-backed integrity: releases are tied to PKI artifacts stored under
  enterprise_os_root/security/pki.
- JWT-based access control where applicable, configured by
  enterprise_os_root/security/jwt_config.json.
- Policy-driven RBAC using Rego (rbac_policy.rego).
- Immutable or append-only logs where required by compliance posture.
