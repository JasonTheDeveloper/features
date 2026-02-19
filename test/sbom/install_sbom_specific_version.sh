#!/usr/bin/env bash

# Scenario: install_sbom_specific_version
# Verifies that a specific version of sbom-tool (3.0.1) installs correctly

set -e

source dev-container-features-test-lib

# Verify sbom-tool is installed
check "sbom-tool is installed" bash -c "which sbom-tool"

# Verify the exact version is installed
check "sbom-tool version is 3.0.1" bash -c "sbom-tool version | grep '3.0.1'"

# Verify sbom-tool binary is in the expected location
check "sbom-tool in /usr/local/bin" bash -c "ls /usr/local/bin/sbom-tool"

reportResults
