# TODO: probably use Brewfile for App Store apps too

# shellcheck shell=bash

function noun_for_mas {
  echo "App Store apps 🍏"
}

function asserts_for_mas {
  [[ "$(uname -s)" == "Darwin" ]] || fail "This Mac App Store component supported only on macOS"
  command -v mas >/dev/null || fail "'mas' command is not installed. It should be installed via Homebrew."
}

function install_or_update_mas {
  if [[ -n "$(mas outdated)" ]]; then
    mas upgrade
  fi
}

function doctor_mas {
  outdated="$(mas outdated)"
  if [[ -n "$outdated" ]]; then
    echo "mas reports outdated apps:"
    echo "$outdated"
  else
    echo "App Store apps are up to date"
  fi
}
