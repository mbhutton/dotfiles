# shellcheck shell=bash

APT_PACKAGES_PATH="${HOME}/.config/mh/desired-state/apt-packages"
APT_BUILD_DEPS_PATH="${HOME}/.config/mh/desired-state/apt-build-deps"

assert_function mh-parse-desired

APT_PACKAGES_ARRAY=()
if [[ -f "$APT_PACKAGES_PATH" ]]; then
  while IFS='' read -r line; do APT_PACKAGES_ARRAY+=("$line"); done < <(mh-parse-desired < "$APT_PACKAGES_PATH")
fi
APT_BUILD_DEPS_ARRAY=()
if [[ -f "$APT_BUILD_DEPS_PATH" ]]; then
  while IFS='' read -r line; do APT_BUILD_DEPS_ARRAY+=("$line"); done < <(mh-parse-desired < "$APT_BUILD_DEPS_PATH")
fi

function noun_for_apt {
  echo "APT Linux packages 🐧"
}

function asserts_for_apt {
  [[ -f "$APT_PACKAGES_PATH" ]] || fail "Desired APT packages file not found: $APT_PACKAGES_PATH"
  [[ -f "$APT_BUILD_DEPS_PATH" ]] || fail "Desired APT packages to build-deps for, not found: $APT_BUILD_DEPS_PATH"
  echo "asserts_for_apt"
}

function install_or_update_apt {
  if [[ "$(uname -o)" == "GNU/Linux" ]] && command -v apt-get >/dev/null; then
    echo "Updating APT package cache... (sudo)"
    sudo apt-get update || fail "Failed to update APT cache"

    local package
    for package in "${APT_PACKAGES_ARRAY[@]}"; do
      echo "Installing (if necessary) APT package: $package (sudo)"
      sudo apt-get install -y "$package" || fail "Failed to install or update APT package: $package"
    done

    local target
    for target in "${APT_BUILD_DEPS_ARRAY[@]}"; do
      echo "Installing (if necessary) APT build-dep package: $target (sudo)"
      sudo apt-get build-dep -y "$target" || fail "Failed to install or update APT build-dep package: $target"
    done

    echo "Upgrading APT packages... (sudo)"
    sudo apt-get upgrade -y || fail "Failed to upgrade packages"
  fi
}

function doctor_apt {
  if [[ "$(uname -o)" == "GNU/Linux" ]] && ! command -v apt-get >/dev/null; then
    echo "apt-get command not found. Update this script to support this non-APT distro"
    echo "Information about this Linux release:"
    [[ -f /etc/os-release ]] && cat /etc/os-release  # lsb_release is not always installed
  fi
}
