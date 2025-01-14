# shellcheck shell=bash

MERMAID_CLI_HOME="$HOME/.local/mh-sw/mermaid-cli"

function noun_for_mermaid {
  echo "Mermaid CLI 🧜"
}

function asserts_for_mermaid {
  command -v mise >/dev/null || fail "mise is not available on PATH"
  command -v just >/dev/null || fail "just is not available on PATH"
  [[ -d "$MERMAID_CLI_HOME" ]] || fail "Mermaid CLI dir not found at $MERMAID_CLI_HOME"
  mise list node | grep -qE '^node.*latest$' || fail "node@latest note installed via mise"
}

function install_or_update_mermaid {
  just --justfile "$MERMAID_CLI_HOME/justfile" update
}

function doctor_mermaid {
  just --justfile "$MERMAID_CLI_HOME/justfile" doctor
}
