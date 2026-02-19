#!/usr/bin/env bash

# This test can be run with the following command (from the root of this repo)
#    devcontainer features test \
#               --features sbom \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.

# Verify sbom-tool is installed and on the PATH
check "sbom-tool is installed" bash -c "which sbom-tool"

# Verify sbom-tool can report its version
check "sbom-tool version runs" bash -c "sbom-tool version"

# Verify sbom-tool is installed to the expected location
check "sbom-tool in /usr/local/bin" bash -c "ls /usr/local/bin/sbom-tool"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
