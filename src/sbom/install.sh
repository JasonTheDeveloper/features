#!/bin/bash

SBOM_TOOL_VERSION="${VERSION:-"latest"}"

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

# Figure out correct version of a three part version number is not passed
validate_version_exists() {
	local variable_name=$1
    local requested_version=$2
	if [ "${requested_version}" = "latest" ]; then requested_version=$(curl -sL https://api.github.com/repos/microsoft/sbom-tool/releases/latest | jq -r ".tag_name"); fi
	local version_list
    version_list=$(curl -sL https://api.github.com/repos/microsoft/sbom-tool/releases | jq -r ".[].tag_name")
	if [ -z "${variable_name}" ] || ! echo "${version_list}" | grep "${requested_version}" >/dev/null 2>&1; then
		echo -e "Invalid ${variable_name} value: ${requested_version}\nValid values:\n${version_list}" >&2
		exit 1
	fi
	echo "${variable_name}=${requested_version}"
}

# make sure we have curl
check_packages curl jq

# make sure version is available
if [ "${SBOM_TOOL_VERSION}" = "latest" ]; then SBOM_TOOL_VERSION=$(curl -sL https://api.github.com/repos/microsoft/sbom-tool/releases/latest | jq -r ".tag_name"); fi
validate_version_exists SBOM_TOOL_VERSION "${SBOM_TOOL_VERSION}"

# download and install binary
SBOM_FILENAME=sbom-tool-linux-x64
SBOM_COMMAND=sbom-tool
echo "Downloading ${SBOM_FILENAME}..."
url="https://github.com/microsoft/sbom-tool/releases/download/${SBOM_TOOL_VERSION}/${SBOM_FILENAME}"
echo "Downloading ${url}..."
curl -sSL https://github.com/microsoft/sbom-tool/releases/download/"${SBOM_TOOL_VERSION}"/"${SBOM_FILENAME}" -o "${SBOM_COMMAND}"
install -m 555 ${SBOM_COMMAND} /usr/local/bin/${SBOM_COMMAND}
rm "${SBOM_FILENAME}"

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
