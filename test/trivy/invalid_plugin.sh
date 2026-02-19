#!/usr/bin/env bash

# Scenario: invalid_plugin
# Verifies that trivy plugin install fails gracefully when given a
# non-existent plugin name. Trivy is installed with defaults so the
# container builds successfully, and we then test the error path.

set -e

source dev-container-features-test-lib

# Trivy should be installed (the scenario uses "latest")
check "trivy is installed" bash -c "which trivy"

# Attempting to install a non-existent plugin should fail (non-zero exit)
check "install of non-existent plugin fails" bash -c '
    if trivy plugin install this-plugin-does-not-exist-xyz 2>&1; then
        echo "ERROR: expected plugin install to fail but it succeeded"
        exit 1
    fi
    echo "Correctly failed to install non-existent plugin"
'

# Verify the fake plugin does NOT appear in the plugin list
check "non-existent plugin is not listed" bash -c \
    "! trivy plugin list 2>&1 | grep -qi 'this-plugin-does-not-exist-xyz'"

reportResults
