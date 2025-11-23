# Enterprise-OS™ Compliance Mapping – Core Environment

This document provides a baseline mapping between Enterprise-OS™ controls
and selected security frameworks.

## 1. NIST SP 800-53 (Selected Controls)

- AC-2: Account Management  
  Enterprise-OS defers to host IAM but provides local RBAC via Rego policy
  (enterprise_os_root/security/rbac_policy.rego).

- AU-2: Audit Events  
  Orchestrator, module launcher, and compliance engine emit logs into
  enterprise_os_root/logs/ and module-specific audit folders.

- CM-6: Configuration Settings  
  Configuration is stored in version-controlled configs and module manifests.
  Checksums and SBOM attest to configuration contents.

## 2. PCI-DSS (Selected Requirements)

- 10.x: Logging and Monitoring  
  Enterprise-OS logs orchestration steps, cloud posture checks, and
  compliance decisions to immutable logs where required.

- 11.x: Regular Testing of Security Systems  
  Multi-cloud posture checks and policy validation scripts support recurring
  security testing workflows.

## 3. CIS Benchmarks (Selected)

Enterprise-OS can run CIS-aligned checks as part of cloud posture workflows,
using the connectors and policy engines defined per provider.
