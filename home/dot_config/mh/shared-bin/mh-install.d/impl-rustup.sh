# shellcheck shell=bash

# Installs or updates rustup and Rust toolchains

# For use by other mh-install.d scripts
function assert_rustup {
  if ! command -v rustup >/dev/null; then
    fail "rustup not found. Suggested fix: \
      install rustup with mh-install, and/or check your PATH."
  fi
}

function install_or_update_rustup {
  if ! command -v rustup >/dev/null; then
      echo "Installing rustup..."
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
      | bash -s -- -y --no-modify-path \
      || fail "Failed to install rustup"
  fi

  if ! rustup toolchain list | grep nightly >/dev/null; then
      echo "Adding rust nightly toolchain..."
      rustup toolchain install nightly \
      || fail "Failed to install rust nightly toolchain"
  fi

  echo "Updating rustup and Rust toolchains..."
  rustup update || fail "Failed to update rustup"
}
