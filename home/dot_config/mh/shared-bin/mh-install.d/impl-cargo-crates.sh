# shellcheck shell=bash

# Installs or updates cargo crate binaries

function install_or_update_cargo_crates {
  echo "Installing (or updating) desired cargo binaries..."
  cargo_binaries="${HOME}/.config/mh/desired-state/cargo-binaries"
  [[ -f "$cargo_binaries" ]] || fail "Desired cargo binaries file not found: $cargo_binaries"

  for binary in $(sed -e 's@#.*@@g' < "$cargo_binaries" | xargs); do
    echo "Installing (or updating) cargo binary: $binary"
    cargo install "$binary" \
    || fail "Failed to install or update cargo binary: $binary"
  done
}
