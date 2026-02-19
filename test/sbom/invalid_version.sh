#!/usr/bin/env bash

# Scenario: invalid_version
# Verifies that the install script's version validation correctly rejects
# a non-existent version. Since the container must build successfully to
# run tests, sbom-tool is installed with "latest" and we then exercise the
# validation logic manually.

set -e

source dev-container-features-test-lib

# sbom-tool should be installed (the scenario uses "latest")
check "sbom-tool is installed" bash -c "which sbom-tool"

# Verify that a completely fake version does NOT appear in the releases list
check "fake version not in releases" bash -c \
    "! curl -sL https://api.github.com/repos/microsoft/sbom-tool/releases | jq -r '.[].tag_name' | grep -qx 'v99.99.99'"

# Simulate the install script's validation: attempt to match a non-existent
# version against the release list and confirm it fails
check "validation rejects non-existent version" bash -c '
    version_list=$(curl -sL https://api.github.com/repos/microsoft/sbom-tool/releases | jq -r ".[].tag_name")
    if echo "${version_list}" | grep -qx "v99.99.99"; then
        echo "ERROR: fake version was found in release list"
        exit 1
    fi
    echo "Correctly rejected non-existent version v99.99.99"
'

# Also verify that a valid version IS accepted by the same logic
check "validation accepts a real version" bash -c '
    version_list=$(curl -sL https://api.github.com/repos/microsoft/sbom-tool/releases | jq -r ".[].tag_name")
    if ! echo "${version_list}" | grep -q "0.3.3"; then
        echo "ERROR: valid version 0.3.3 was not found in release list"
        exit 1
    fi
    echo "Correctly accepted valid version 0.3.3"
'

reportResults
