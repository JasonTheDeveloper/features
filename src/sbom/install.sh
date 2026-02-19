#!/bin/bash

SBOM_TOOL_VERSION="${VERSION:-"latest"}"
SBOM_ALIAS="${ALIAS:="sbom-tool"}"

set -e

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
	echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
	exit 1
fi

# Checks if packages are installed and installs them if not
check_packages() {
	if ! dpkg -s "$@" >/dev/null 2>&1; then
		if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
			echo "Running apt-get update..."
			apt-get update -y
		fi
		apt-get -y install --no-install-recommends "$@"
	fi
}

# Resolve "latest" version by following the GitHub redirect (no API rate limit)
resolve_latest_version() {
	local latest_url="https://github.com/microsoft/sbom-tool/releases/latest"
	local redirect_url
	redirect_url=$(curl -sIL -o /dev/null -w '%{url_effective}' "${latest_url}")
	if [ -z "${redirect_url}" ] || [ "${redirect_url}" = "${latest_url}" ]; then
		echo "ERROR: Failed to resolve latest sbom-tool version from GitHub." >&2
		exit 1
	fi
	# Extract tag from redirect URL (e.g. .../releases/tag/v4.1.5 -> v4.1.5)
	echo "${redirect_url##*/}"
}

# Validate that a given version/tag exists by checking the download URL returns 200
validate_version_exists() {
	local variable_name=$1
	local requested_version=$2
	local check_url="https://github.com/microsoft/sbom-tool/releases/tag/${requested_version}"
	local http_code
	http_code=$(curl -sIL -o /dev/null -w '%{http_code}' "${check_url}")
	if [ "${http_code}" != "200" ]; then
		echo "ERROR: ${variable_name} value '${requested_version}' not found (HTTP ${http_code})." >&2
		echo "Check available versions at: https://github.com/microsoft/sbom-tool/releases" >&2
		exit 1
	fi
	echo "${variable_name}=${requested_version}"
}

# make sure we have curl
check_packages curl ca-certificates libicu-dev

# Normalize version: add 'v' prefix if missing
if [ "${SBOM_TOOL_VERSION}" != "latest" ] && [[ "${SBOM_TOOL_VERSION}" != v* ]]; then
	SBOM_TOOL_VERSION="v${SBOM_TOOL_VERSION}"
fi

# Resolve latest or validate the requested version
if [ "${SBOM_TOOL_VERSION}" = "latest" ]; then
	SBOM_TOOL_VERSION=$(resolve_latest_version)
fi
validate_version_exists SBOM_TOOL_VERSION "${SBOM_TOOL_VERSION}"

# download and install binary
SBOM_FILENAME=sbom-tool-linux-x64
echo "Downloading ${SBOM_FILENAME}..."
url="https://github.com/microsoft/sbom-tool/releases/download/${SBOM_TOOL_VERSION}/${SBOM_FILENAME}"
echo "Downloading ${url}..."
curl -sSL https://github.com/microsoft/sbom-tool/releases/download/"${SBOM_TOOL_VERSION}"/"${SBOM_FILENAME}" -o "${SBOM_ALIAS}"
install -m 555 ${SBOM_ALIAS} /usr/local/bin/${SBOM_ALIAS}
rm "${SBOM_ALIAS}"

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
