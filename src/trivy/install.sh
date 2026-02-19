#!/bin/bash

TRIVY_VERSION="${VERSION:-"latest"}"
TRIVY_PLUGINS="${PLUGINS:-""}"
TRIVY_HOME="/usr/local/share/trivy"

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

# Resolve "latest" to the actual latest version tag, and validate that the
# requested version exists in the GitHub releases.
resolve_and_validate_version() {
	local requested_version=$1

	if [ "${requested_version}" = "latest" ]; then
		requested_version=$(curl -sL https://api.github.com/repos/aquasecurity/trivy/releases/latest | jq -r ".tag_name")
		if [ -z "${requested_version}" ] || [ "${requested_version}" = "null" ]; then
			echo "Failed to fetch the latest Trivy version." >&2
			exit 1
		fi
	fi

	# Ensure the version starts with "v"
	if [[ "${requested_version}" != v* ]]; then
		requested_version="v${requested_version}"
	fi

	# Validate the version exists
	local version_list
	version_list=$(curl -sL https://api.github.com/repos/aquasecurity/trivy/releases | jq -r ".[].tag_name")
	if ! echo "${version_list}" | grep -qx "${requested_version}"; then
		echo -e "Invalid Trivy version: ${requested_version}\nValid recent versions:\n${version_list}" >&2
		exit 1
	fi

	echo "${requested_version}"
}

# Install Trivy plugins. Accepts a comma or space separated list of plugin names.
install_plugins() {
	local plugins_input=$1

	# Replace commas with spaces to normalize the separator
	local plugins
	plugins=$(echo "${plugins_input}" | tr ',' ' ')

	for plugin in ${plugins}; do
		# Trim whitespace
		plugin=$(echo "${plugin}" | xargs)
		if [ -n "${plugin}" ]; then
			echo "Installing Trivy plugin: ${plugin}..."
			trivy plugin install "${plugin}"
		fi
	done
}

# Make sure we have required dependencies
check_packages curl jq ca-certificates

# Resolve and validate the version
echo "Resolving Trivy version '${TRIVY_VERSION}'..."
TRIVY_VERSION=$(resolve_and_validate_version "${TRIVY_VERSION}")
echo "Installing Trivy ${TRIVY_VERSION}..."

# Install Trivy using the official convenience script
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin "${TRIVY_VERSION}"

# Verify installation
trivy --version

# Set up shared TRIVY_HOME so plugins are available to all users.
# Create a wrapper script that ensures TRIVY_HOME is always set, regardless
# of how trivy is invoked (login shell, non-interactive sh -c, etc.).
mkdir -p "${TRIVY_HOME}"
mv /usr/local/bin/trivy /usr/local/bin/trivy-real
cat > /usr/local/bin/trivy << WRAPPER
#!/bin/sh
export TRIVY_HOME="\${TRIVY_HOME:-${TRIVY_HOME}}"
exec /usr/local/bin/trivy-real "\$@"
WRAPPER
chmod +x /usr/local/bin/trivy
export TRIVY_HOME

# Install plugins if specified
if [ -n "${TRIVY_PLUGINS}" ]; then
	echo "Installing Trivy plugins..."
	install_plugins "${TRIVY_PLUGINS}"
fi

chmod -R a+rX "${TRIVY_HOME}"

# Clean up
rm -rf /var/lib/apt/lists/*

echo "Done!"
