
# Trivy (trivy)

A feature to install Trivy to scan for vulnerabilities in container images, file systems, and Git repositories

## Example Usage

```json
"features": {
    "ghcr.io/JasonTheDeveloper/features/trivy:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter Trivy version | string | latest |
| plugins | Select or enter additional plugins to install with Trivy (e.g., mcp for Model Context Protocol plugin) | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/JasonTheDeveloper/features/blob/main/src/trivy/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
