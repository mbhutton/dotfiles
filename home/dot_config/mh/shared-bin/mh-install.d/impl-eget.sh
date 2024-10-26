# shellcheck shell=bash

# See eget.toml for desired packages and their configuration

function noun_for_eget {
  echo "Eget (Github packages) 📦"
}

function asserts_for_eget {
  command -v eget >/dev/null || fail "eget not found on PATH"
  [[ -n "${EGET_BIN}" ]] || fail "EGET_BIN not set"
  [[ -d "${EGET_BIN}" ]] || fail "EGET_BIN is not a directory"
}

function install_or_update_eget {
  eget --download-all || fail "Failed to install or update eget packages"
}

function doctor_eget {
  echo "(no-op)"
}

