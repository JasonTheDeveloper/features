#!/usr/bin/env bash

# Scenario: install_trivy_specific_version
# Verifies that a specific version of trivy (without "v" prefix) installs correctly

set -e

source dev-container-features-test-lib

# Verify trivy is installed
check "trivy is installed" bash -c "which trivy"

# Verify the exact version is installed (0.69.1)
check "trivy version is 0.69.1" bash -c "trivy --version | grep '0.69.1'"

reportResults
