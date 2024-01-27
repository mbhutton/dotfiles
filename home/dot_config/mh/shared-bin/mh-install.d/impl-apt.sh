# shellcheck shell=bash

APT_PACKAGES_PATH="${HOME}/.config/mh/desired-state/apt-packages"

assert_function mh-parse-desired

APT_PACKAGES_ARRAY=()
if [[ -f "$APT_PACKAGES_PATH" ]]; then
  while IFS='' read -r line; do APT_PACKAGES_ARRAY+=("$line"); done < <(mh-parse-desired < "$APT_PACKAGES_PATH")
fi

function noun_for_apt {
  echo "APT Linux packages 🐧"
}

function asserts_for_apt {
  [[ -f "$APT_PACKAGES_PATH" ]] || fail "Desired APT packages file not found: $APT_PACKAGES_PATH"
  echo "asserts_for_apt"
}

function install_or_update_apt {
  if [[ "$(uname -o)" == "GNU/Linux" ]] && command -v apt >/dev/null; then
    echo "Updating APT package cache... (sudo)"
    sudo apt update || fail "Failed to update apt cache"

    local package
    for package in "${APT_PACKAGES_ARRAY[@]}"; do
      echo "Installing (if necessary) APT package: $package (sudo)"
      sudo apt install -y "$package" || fail "Failed to install or update APT package: $package"
    done

    echo "Upgrading APT packages... (sudo)"
    sudo apt upgrade -y || fail "Failed to upgrade packages"
  fi
}

function doctor_apt {
  if [[ "$(uname -o)" == "GNU/Linux" ]] && ! command -v apt >/dev/null; then
    echo "apt command not found. Update this script to support this non-APT distro"
    echo "Information about this Linux release:"
    [[ -f /etc/os-release ]] && cat /etc/os-release  # lsb_release is not always installed
  fi
}
