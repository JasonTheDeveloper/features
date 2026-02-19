#!/usr/bin/env bash

# Scenario: install_trivy_with_plugin
# Verifies that trivy installs with the mcp plugin

set -e

source dev-container-features-test-lib

# Verify trivy is installed
check "trivy is installed" bash -c "which trivy"

# Verify trivy version runs
check "trivy version runs" bash -c "trivy --version"

# Verify the mcp plugin is installed
check "mcp plugin is installed" bash -c "trivy plugin list | grep -i 'mcp'"

reportResults
