#!/usr/bin/env bash

# Scenario: install_sbom_latest
# Verifies that sbom-tool installs successfully when version is set to "latest"

set -e

source dev-container-features-test-lib

# Verify sbom-tool is installed
check "sbom-tool is installed" bash -c "which sbom-tool"

# Verify sbom-tool version output is not empty
check "sbom-tool version reports output" bash -c "sbom-tool version"

# Verify sbom-tool binary is in the expected location
check "sbom-tool in /usr/local/bin" bash -c "ls /usr/local/bin/sbom-tool"

reportResults
