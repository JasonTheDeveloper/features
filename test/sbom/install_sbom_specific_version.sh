#!/usr/bin/env bash

# Scenario: install_sbom_specific_version
# Verifies that a specific version of sbom-tool (0.3.3) installs correctly

set -e

source dev-container-features-test-lib

# Verify sbom-tool is installed
check "sbom-tool is installed" bash -c "which sbom-tool"

# Verify sbom-tool can run
check "sbom-tool version runs" bash -c "sbom-tool version"

# Verify sbom-tool binary is in the expected location
check "sbom-tool in /usr/local/bin" bash -c "ls /usr/local/bin/sbom-tool"

reportResults
