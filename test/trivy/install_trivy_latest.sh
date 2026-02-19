#!/usr/bin/env bash

# Scenario: install_trivy_latest
# Verifies that trivy installs successfully when version is set to "latest"

set -e

source dev-container-features-test-lib

# Verify trivy is installed
check "trivy is installed" bash -c "which trivy"

# Verify trivy version output is not empty
check "trivy version reports output" bash -c "trivy --version | grep -i 'version'"

# Verify trivy binary is in the expected location
check "trivy in /usr/local/bin" bash -c "ls /usr/local/bin/trivy"

reportResults
