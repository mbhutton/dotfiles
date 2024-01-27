# TODO: probably use Brewfile for App Store apps too

# shellcheck shell=bash

SKIP_MH_INSTALL_MAS=
# TODO: do this via Chezmoi instead
if [[ "$(uname -s)" != "Darwin" || -n "$(system_profiler SPHardwareDataType | grep -E 'Chip: .*Virtual')" ]]; then
  SKIP_MH_INSTALL_MAS=skip  # non macOS, or virtual machine
fi

function noun_for_mas {
  echo "App Store apps 🍏"
}

function asserts_for_mas {
  if [[ "$SKIP_MH_INSTALL_MAS" != "skip" ]]; then
    command -v mas >/dev/null || {
      echo "'mas' is not installed. Should be installed via Homebrew."
      return 1
    }
  fi
}

function install_or_update_mas {
  if [[ "$SKIP_MH_INSTALL_MAS" != "skip" ]]; then
    if [[ -n "$(mas outdated)" ]]; then
      mas upgrade
    fi
  fi
}

function doctor_mas {
  if [[ "$SKIP_MH_INSTALL_MAS" != "skip" ]]; then
    outdated="$(mas outdated)"
    if [[ -n "$outdated" ]]; then
      echo "mas reports outdated apps:"
      echo "$outdated"
    else
      echo "App Store apps are up to date"
    fi
  fi
}
