# Enterprise-OS™ Cross-Framework Compliance Summary

This report aggregates compliance log outputs from:

  - get_paid/enterprise_os_projects/aegis/audits/
  - get_paid/enterprise_os_projects/chimera/audits/
  - get_paid/enterprise_os_projects/clarity/audits/
  - get_paid/enterprise_os_projects/connect/audits/
  - get_paid/enterprise_os_projects/orchard/audits/
  - get_paid/enterprise_os_projects/sentry/audits/
  - get_paid/enterprise_os_projects/synergy/audits/
  - get_paid/enterprise_os_projects/veritas/audits/

Each project includes:

  - *_sbom_spdx.json
  - *_mbom_cyclonedx.json
  - *_compliance.log
  - *_secrets.log

Summary (example):

  - No high-severity hard-coded secrets detected.
  - Moderate issues: inline policies, legacy TLS, missing tags.
  - All issues are actionable via Enterprise-OS orchestrated remediation plans.
