#!/usr/bin/env bash
# /*
#  * Copyright © 2025 Devin B. Royal.
#  * All Rights Reserved.
#  */

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SBOM_DIR="${ROOT_DIR}/sbom"
VERSION="${ENTERPRISE_OS_VERSION:-0.1.0-demo}"

mkdir -p "${SBOM_DIR}"

if ! command -v syft >/dev/null 2>&1; then
  echo "ERROR: syft not found. Install syft (e.g., 'brew install syft' or 'docker pull anchore/syft')." >&2
  exit 1
fi

syft dir:"${ROOT_DIR}/enterprise_os_root" -o cyclonedx-json > "${SBOM_DIR}/enterprise-os-root-${VERSION}.json"

echo "SBOM written to ${SBOM_DIR}/enterprise-os-root-${VERSION}.json"

# /*
#  * Copyright © 2025 Devin B. Royal.
#  * All Rights Reserved.
#  */
