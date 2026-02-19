#!/usr/bin/env bash

# Scenario: install_sbom_custom_alias
# Verifies that sbom-tool installs with a custom alias ("msft-sbom")

set -e

source dev-container-features-test-lib

# Verify the custom alias is available on the PATH
check "msft-sbom is installed" bash -c "which msft-sbom"

# Verify the custom alias can report its version
check "msft-sbom version runs" bash -c "msft-sbom version"

# Verify the binary is in the expected location under the custom alias
check "msft-sbom in /usr/local/bin" bash -c "ls /usr/local/bin/msft-sbom"

# Verify the default alias is NOT present (only the custom alias should exist)
check "default sbom-tool alias not present" bash -c "! which sbom-tool"

reportResults
