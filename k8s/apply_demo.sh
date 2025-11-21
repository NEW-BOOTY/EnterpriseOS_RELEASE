#!/usr/bin/env bash
# /*
#  * Copyright © 2025 Devin B. Royal.
#  * All Rights Reserved.
#  */

set -euo pipefail

kubectl apply -f k8s/demo-namespace.yaml
kubectl apply -f k8s/minio.yaml
kubectl apply -f k8s/control-plane.yaml

kubectl -n enterprise-os-demo get pods

# /*
#  * Copyright © 2025 Devin B. Royal.
#  * All Rights Reserved.
#  */
