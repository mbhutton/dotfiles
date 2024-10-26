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

  MISE_PACKAGE='jdx/mise'
  echo "Installing or updating $MISE_PACKAGE"
  eget "$MISE_PACKAGE" --asset='.tar.gz' --asset='^musl' --file='mise/bin/mise' --to="$EGET_BIN_DIR" --upgrade-only \
  || fail "Failed to install or update eget package: $MISE_PACKAGE"
}

function doctor_eget {
  echo "(no-op)"
}

