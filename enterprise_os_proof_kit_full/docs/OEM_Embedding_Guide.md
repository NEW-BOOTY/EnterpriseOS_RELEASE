# OEM Embedding Guide

OEMs can embed Enterprise-OS™ into appliances by:

- Using Dockerfile.control-plane and k8s_manifests/*-deployment.yaml for
  cluster-based control planes.
- Shipping enterprise_os_root/ modules pre-integrated with hardware
  capabilities.
- Leveraging systemd unit files in */systemd/*.service for service startup.
