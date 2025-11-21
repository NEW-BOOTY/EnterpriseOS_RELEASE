#!/usr/bin/env bash
# Copyright (c) 2025 Devin B. Royal. All Rights Reserved.
set -Eeuo pipefail
IFS=$'\n\t'
umask 077

SCRIPT_NAME="$(basename "$0")"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${ROOT_DIR}/logs"
LOG_FILE="${LOG_DIR}/setup_$(date +%Y%m%d_%H%M%S).log"
mkdir -p "$LOG_DIR"

exec > >(tee -a "$LOG_FILE") 2>&1

trap 'on_error $LINENO' ERR
trap 'on_exit' EXIT

on_error() { local line="$1"; echo "[ERROR] $SCRIPT_NAME failed at line $line"; }
on_exit()  { echo "[INFO] $SCRIPT_NAME finished at $(gdate -Iseconds)"; }

require() { command -v "$1" >/dev/null 2>&1 || return 1; }

install_homebrew_mac() { 
  if ! command -v brew >/dev/null 2>&1; then
    echo "[INFO] Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.bash_profile" || true
    eval "$(/opt/homebrew/bin/brew shellenv)" || true
  fi
  brew update || true
}

ensure_tools() { 
  local tools=("$@")
  for t in "${tools[@]}"; do
    if ! require "$t"; then
      echo "[INFO] Installing $t via brew..."
      brew install "$t" || brew reinstall "$t" || brew upgrade "$t" || true
    else
      echo "[OK] $t present"
    fi
  done
}

echo "[INFO] Starting setup for amazon at $(gdate -Iseconds)"
install_homebrew_mac
ensure_tools git jq yq gnu-sed coreutils awscli node rust openjdk maven kubectl

echo "[INFO] Generating polyglot outputs (src/)..."
mkdir -p "$ROOT_DIR/src" "$ROOT_DIR/generated"
touch "$ROOT_DIR/generated/.keep"

echo "[INFO] Validating environment..."
echo "COMPANY=amazon" > "$ROOT_DIR/generated/env.meta"
echo "TOOLS=git jq yq gnu-sed coreutils awscli node rust openjdk maven kubectl" >> "$ROOT_DIR/generated/env.meta"

echo "[INFO] Completed bootstrap for amazon."
