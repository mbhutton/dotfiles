#!/bin/bash

# Follow up to install-for-linux.sh which refreshes using chezmoi and mh-install
# depending on the given args:
# --cachebust from within the Dockerfile, or --devcontainer as the dev container post create command.

set -e # -e: exit on error

function fail {
  echo "$*" >&2
  echo "Usage: $0 [--cachebust <CACHEBUST> | --devcontainer ]" >&2
  exit 1
}

function draw_line() {
  for _ in {1..120}; do
    echo -n "_"
  done
  echo
}

# Parse arguments, and exit early if a refresh is not appropriate.
[[ $# -gt 0 ]] || fail "No arguments provided"
if [[ "$1" == "--cachebust" ]]; then
  [[ $# -eq 2 ]] || fail
  CACHEBUST="$2"
  if [[ "$CACHEBUST" == "default" ]]; then
    echo "SKIPPING: Not rereshing here because CACHEBUST was left as default value, indicating a devcontainer build."
    exit 0
  fi
elif [[ "$1" == "--devcontainer" ]]; then
  # TODO: skip when inside a *codespace* container, which is expecting to not be caching in the way that this cache busting addresses.
  true
else
  fail "Unknown argument: $1"
fi

draw_line
echo "Refreshing chezmoi configuration"
/usr/bin/zsh -i -c "chezmoi update --init --force"

draw_line
echo "Running mh-install to update tools"
/usr/bin/zsh -i -c mh-install

draw_line
echo "Refresh complete 🥳"
