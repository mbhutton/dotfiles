# shellcheck shell=bash

# Installs or updates cargo crate binaries

CARGO_BINARIES_PATH="${HOME}/.config/mh/desired-state/cargo-binaries"

assert_function mh-parse-desired

CARGO_BINARIES_ARRAY=()
if [[ -f "$CARGO_BINARIES_PATH" ]]; then
  while IFS='' read -r line; do CARGO_BINARIES_ARRAY+=("$line"); done < <(mh-parse-desired < "$CARGO_BINARIES_PATH")
fi

function noun_for_cargo-crates {
  echo "Cargo crates 🦀📦"
}

function asserts_for_cargo-crates {
  [[ -f "$CARGO_BINARIES_PATH" ]] || fail "Desired cargo binaries file not found: $CARGO_BINARIES_PATH"
  command -v cargo >/dev/null || fail "cargo not found on PATH"
}

function install_or_update_cargo-crates {
  local binary

  echo "Installing (or updating) desired cargo binaries..." ; echo

  for binary in "${CARGO_BINARIES_ARRAY[@]}"; do
    echo "Installing (or updating) cargo binary: $binary"
    cargo install "$binary" \
    || fail "Failed to install or update cargo binary: $binary"
  done

  # TODO: update *all*, not just desired (for other components too!)
}

function check_cargo-crates { # TODO this seems unused
  local binary
  for binary in "${CARGO_BINARIES_ARRAY[@]}"; do
    echo "Checking cargo binary: $binary"
    if ! cargo install --list | grep "$binary" >/dev/null; then
      echo "Cargo binary not installed: $binary"
      return 1
    fi
  done
}

function doctor_cargo-crates {
  true
  # TODO: check for unexpected cargo binaries using 'cargo install --list', ideally in a more parseable format
}
