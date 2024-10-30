# shellcheck shell=bash

# See ~/.config/mise/settings.toml

function noun_for_mise {
  echo "language runtimes (via Mise) 🍽️"
}

function asserts_for_mise {
  command -v mise >/dev/null || fail "mise is not installed"
}

function install_or_update_mise {
  # TODO: consider doing this via chezmoi instead. note: mise paranoid mode is more for limiting plugins rather than distrusting config
  mise trust "$HOME/.config/mise/config.toml"
  mise upgrade

  # TODO why are bootstrap calls somehow not activating mise? maybe *always* activate it?
  if [[ "$PATH" != *"/mise/installs/"* ]]; then
    eval "$(/usr/bin/env mise activate bash)"
  fi
}

function doctor_mise {
  prune_output="$(mise prune --dry-run)"
  if [[ -n "$prune_output" ]]; then
    echo "Mise reports packages able to be pruned:"
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

