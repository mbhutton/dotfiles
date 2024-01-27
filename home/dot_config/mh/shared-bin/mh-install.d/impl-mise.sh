# shellcheck shell=bash

# See ~/.config/mise/settings.toml

function noun_for_mise {
  echo "language runtimes (via Mise) 🍽️"
}

function asserts_for_mise {
  echo "asserts_for_mise"
}

function install_or_update_mise {
  # TODO: consider doing this via chezmoi instead. note: mise paranoid mode is more for limiting plugins rather than distrusting config
  command -v mise >/dev/null && mise trust "$HOME/.config/mise/config.toml"

  command -v mise >/dev/null && mise upgrade

  if [[ "$PATH" != *"/mise/installs/"* ]]; then
    command -v mise > /dev/null && eval "$(/usr/bin/env mise activate bash)"
  fi
}

function doctor_mise {
  if ! command -v mise >/dev/null; then
    echo "Mise is not available"
    return 0
  fi
  prune_output="$(mise prune --dry-run)"
  if [[ -n "$prune_output" ]]; then
    echo "Mise reports pruneable packages:"
    echo "$prune_output"
  fi

  diagnosis="$(mise doctor --quiet)"
  if [[ "$diagnosis" == *"No warnings found"* && "$diagnosis" == *"No problems found"* ]]; then
    echo "Mise doctor reports no issues"
  else
    echo "Mise doctor reports issues:"
    echo "$diagnosis"
  fi

  # TODO: show if anything installed that isn't in settings
}

