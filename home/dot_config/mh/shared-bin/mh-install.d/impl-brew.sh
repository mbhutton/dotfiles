# shellcheck shell=bash

# See: Brewfile

function noun_for_brew {
  echo "Homebrew packages 🍺"
}

function asserts_for_brew {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Homebrew is only supported on macOS"
    return
  fi
}

function install_or_update_brew {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Homebrew is only supported on macOS"
    return
  fi

  if ! command -v brew >/dev/null && [[ ! -f "/opt/homebrew/bin/brew" ]]; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || fail "Failed to install Homebrew"
    [[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
    command -v brew >/dev/null || fail "Homebrew not found after installation"
  else
    command -v brew >/dev/null || fail "Homebrew appears to be in a partially installed state"
    # TODO handle the case where brew is installed but not in PATH
  fi

  echo "Syncing Homebrew packages using Brewfile..." ; echo
  [[ -f "${HOME}/.Brewfile" ]] || fail "Brewfile not found: ${HOME}/.Brewfile"
  brew update || fail "Failed to update Homebrew"
  brew bundle install --quiet --cleanup --global || fail "Failed to install Homebrew packages using Brewfile"
  brew upgrade || fail "Failed to upgrade Homebrew packages"
  [[ -z "$(brew outdated)" ]] || fail "Brew reported outdated packages after upgrading"
}

function doctor_brew {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Homebrew is only supported on macOS"
    return
  fi
  if ! command -v brew >/dev/null 2>&1; then
    echo "Brew command not found" >&2
    return 0
  fi
  # shellcheck disable=SC2143
  if [[ -n "$(brew outdated --cask --greedy --verbose | grep -v '(latest) != latest')" ]]; then
    echo "Homebrew reports outdated casks: $(brew outdated --cask --greedy --verbose)"
  fi

  diagnosis="$(brew doctor 2>&1)"

  read -r -d '' clean_bill_of_health <<'EOF'
Your system is ready to brew.
EOF

  read -r -d '' existing_preconditions <<'EOF'
Please note that these warnings are just used to help the Homebrew maintainers
with debugging if you file an issue. If everything you use Homebrew for is
working fine: please don't worry or file an issue; just ignore this. Thanks!

Warning: You have unlinked kegs in your Cellar.
Leaving kegs unlinked can lead to build-trouble and cause formulae that depend on
those kegs to fail to run properly once built. Run `brew link` on these:
  choose-gui
EOF

  if [[ "$diagnosis" == "$existing_preconditions" || "$diagnosis" == "$clean_bill_of_health" ]]; then
    echo "Homebrew doctor reports no issues"
  else
    echo "Homebrew doctor reports issues:"
    echo "diagnosis: $diagnosis"
    echo "preconditions: $existing_preconditions"
    echo "$diagnosis"
  fi
}
