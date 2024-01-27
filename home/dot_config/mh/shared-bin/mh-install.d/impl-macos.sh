# shellcheck shell=bash
#
# Report updates are available in doctor stage

function noun_for_macos {
  echo "macOS software 🍏"
}

function asserts_for_macos {
  true # No-op
}

function install_or_update_macos {
  echo "(No-op) - Check the doctor stage for available updates."
}

function doctor_macos {
  if [[ "$(uname -s)" != "Darwin" ]]; then
    return
  fi

  available_updates="$(softwareupdate --list 2>&1 \
    | grep -v 'Software Update Tool' \
    | grep -v 'Finding available software' \
    | grep -v 'No new software available.' \
    | grep -vE '^$'\
    )"

  read -r -d '' no_software_updates <<'EOF'
Software Update Tool

Finding available software
No new software available.
EOF

  if [[ -n "$available_updates" ]]; then
    echo "Software updates are available:"
    echo "$available_updates"
  else
    echo "macOS software is up to date"
  fi

}




