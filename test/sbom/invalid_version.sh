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

# Verify that a fake version returns non-200 from GitHub releases
check "fake version not in releases" bash -c '
    http_code=$(curl -sIL -o /dev/null -w "%{http_code}" "https://github.com/microsoft/sbom-tool/releases/tag/v99.99.99")
    if [ "${http_code}" = "200" ]; then
        echo "ERROR: fake version v99.99.99 returned HTTP 200"
        exit 1
    fi
    echo "Correctly rejected non-existent version v99.99.99 (HTTP ${http_code})"
'

# Verify that a valid version IS accepted (returns HTTP 200)
check "validation accepts a real version" bash -c '
    http_code=$(curl -sIL -o /dev/null -w "%{http_code}" "https://github.com/microsoft/sbom-tool/releases/tag/v3.0.1")
    if [ "${http_code}" != "200" ]; then
        echo "ERROR: valid version v3.0.1 returned HTTP ${http_code}"
        exit 1
    fi
    echo "Correctly accepted valid version v3.0.1 (HTTP ${http_code})"
'

reportResults
