# shellcheck shell=bash

function noun_for_lint {
  echo "source file linter 🔎"
}

function asserts_for_lint {
  command -v just >/dev/null 2>&1 || fail "just not found"
}

function install_or_update_lint {
  true
}

function doctor_lint {
  mr lint
}
