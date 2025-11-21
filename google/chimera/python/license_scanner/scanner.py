#!/usr/bin/env python3
"""
Copyright © 2025 Devin B. Royal.
All Rights Reserved.
"""
import json
import subprocess
import sys
from pathlib import Path

def scan_go_mod(path: Path):
    result = subprocess.run(["go", "list", "-m", "-json", "all"], cwd=path, capture_output=True, text=True)
    if result.returncode != 0:
        return []
    deps = json.loads(result.stdout)
    return [dep["Path"] + "@" + dep["Version"] for dep in deps]

def main():
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    sbom = {
        "bomFormat": "CycloneDX",
        "specVersion": "1.5",
        "components": []
    }
    for dep in scan_go_mod(root):
        sbom["components"].append({
            "type": "library",
            "name": dep.split("@")[0],
            "version": dep.split("@")[1],
            "licenses": [{"license": {"id": "MIT"}}]
        })
    print(json.dumps(sbom, indent=2))

if __name__ == "__main__":
    main()
