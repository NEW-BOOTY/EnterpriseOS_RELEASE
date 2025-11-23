# Module Health Assurance

Enterprise-OS modules expose health information via health_check.txt files
and build logs within enterprise_os_root/modules/*.

- A value of "OK" or recent successful build log indicates a healthy module.
- Integration test failures or missing artifacts are flagged for remediation.
