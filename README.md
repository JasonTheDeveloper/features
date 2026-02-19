# Dev Container Features

This repository contains the following dev container features:

- [sbom](./src/sbom/README.md): this installs Microsoft's [sbom-tool](https://github.com/microsoft/sbom-tool) used to aid in generating SPDX 2.2 SBOMs (Software Bill of Material)
- [trivy](./src/trivy/README.md): this installs [Trivy](https://github.com/aquasecurity/trivy) to scan for vulnerabilities in container images, file systems, and Git repositories

## Example Usage

```json
"features": {
    "ghcr.io/JasonTheDeveloper/features/sbom:1": {},
    "ghcr.io/JasonTheDeveloper/features/trivy:1": {}
}
```
