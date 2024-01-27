# shellcheck shell=bash

function noun_for_eget {
  echo "Eget (Github packages) 📦"
}

function asserts_for_eget {
  command -v eget >/dev/null || fail "eget not found on PATH"
}

function install_or_update_eget {
  EGET_BIN_DIR="${HOME}/.local/share/mh/eget-bin"
  mkdir -p "$EGET_BIN_DIR" || fail "Failed to create eget-bin directory at $EGET_BIN_DIR"


function doctor_eget {
  echo "(no-op)"
}

