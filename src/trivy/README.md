
# Trivy (trivy)

A feature to install Trivy to scan for vulnerabilities in container images, file systems, and Git repositories.

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

### version

The version of Trivy to install. Set to `"latest"` (default) to automatically fetch the most recent release, or specify an exact version such as `"0.69.1"`. The installer will validate that the requested version exists before proceeding.

### plugins

A comma or space separated list of Trivy plugins to install after Trivy itself is set up. For example:

```json
"features": {
    "ghcr.io/JasonTheDeveloper/features/trivy:1": {
        "version": "latest",
        "plugins": "mcp"
    }
}
```

Multiple plugins can be specified:

```json
"plugins": "plugin1, plugin2"
```

---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/JasonTheDeveloper/features/blob/main/src/trivy/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
