# shellcheck shell=bash

# Installs or updates rustup and Rust toolchains

# For use by other mh-install.d scripts
#

function noun_for_rustup {
  echo "Rust toolchain (via rustup) 🦀"
}

function asserts_for_rustup {
  true
  # if ! command -v rustup >/dev/null; then
  #   fail "rustup not found. Suggested fix: \
  #     install rustup with mh-install, and/or check your PATH."
  # fi
}

function install_or_update_rustup {
  echo "Installing or updating rustup..." ; echo

  if ! command -v rustup >/dev/null && [[ ! -f "$HOME/.cargo/bin/rustup" ]]; then
      echo "Installing rustup..."
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
      | bash -s -- -y --no-modify-path \
      || fail "Failed to install rustup"

      if [[ -f "$HOME/.cargo/env" ]]; then
        echo "Reading cargo variables into the script's environment for downstream components..."
        source "$HOME/.cargo/env"
      else
        echo "WARN: No cargo env file found at $HOME/.cargo/env . Later rust commands will fail."
      fi
  else
      command -v rustup >/dev/null || fail "rustup appears to be in a half installed state"
      # TODO handle the case where rustup is installed but not in PATH
  fi

  # if ! rustup toolchain list | grep nightly >/dev/null; then
  #     echo "Adding rust nightly toolchain..."
  #     rustup toolchain install nightly \
  #     || fail "Failed to install rust nightly toolchain"
  # fi

  echo "Performing rustup self-update..."
  rustup self update || fail "Failed to self-update rustup"

  rustup default stable || fail "Failed to set default toolchain to stable"

  echo "Updating rustup and Rust toolchains..."
  rustup update || fail "Failed to update rustup"

}

function doctor_rustup {
  echo "Checking rustup..."
  # TODO: Add more checks, e.g. that no updates available and all up to date. using rustup check
  rustup --version
}
