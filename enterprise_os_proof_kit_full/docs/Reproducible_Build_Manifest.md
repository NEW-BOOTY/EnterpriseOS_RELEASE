# Reproducible Build Manifest

Example build environment:

- OS: Ubuntu 22.04 LTS (x86_64)
- Runtime: OpenJDK 21.x, Python 3.11+
- Tools: Maven, Go toolchain, Rust (for Lambdaloom), Swift (for Orchard),
  .NET SDK (for Aegis/AzureWeave).

Steps (high level):

1. Validate source integrity using git signatures and checksums.
2. Run language-specific builds (Maven, go build, cargo build, dotnet build).
3. Execute enterprise_os_build.sh and enterprise_os_deploy.sh for unified build.
4. Generate SBOM using scripts/generate_sbom.sh.
5. Capture sha256 checksums of resulting bundles and binaries.

Build timestamp example: 2025-11-23T06:16:28Z
