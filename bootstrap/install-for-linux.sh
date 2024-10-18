#!/bin/bash

# Ensures preconditions, then installs these dotfiles using Chezmoi,
# then runs mh-install to install dev tools.
# Main targets are Debian Docker containers and tart's Debian VMs.

set -e # -e: exit on error

function fail {
  echo "$*" >&2
  exit 1
}

function draw_line() {
  for _ in {1..120}; do
    echo -n "_"
  done
  echo
}

draw_line
echo "Checking prerequisites"
[[ "$(uname -s)" == "Linux" ]] || fail "This script targets Linux only"
[[ -n "$USER" ]] || fail "USER is not set"
[[ -n "$HOME" ]] || fail "HOME is not set"

draw_line
echo "Installing and upgrading prequisites via APT"
sudo apt-get update || fail "Failed to update apt"
sudo apt-get install -y curl git zsh || fail "Failed to install prequisites via APT"

draw_line
echo "Ensuring that shell is Zsh"
sudo chsh -s "$(which zsh)" "$USER" || fail "Failed to set shell to Zsh"

draw_line
echo "Installing dotfiles (dev branch) using Chezmoi"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mbhutton --branch dev || fail "Failed to install dotfiles using Chezmoi"

draw_line
echo "Installing dev tools using mh-install"
zsh -i -c mh-install || fail "Failed to install dev tools using mh-install"

draw_line
if [[ -f "bin/chezmoi" ]]; then
  echo "Deleting temporary chezmoi binary directory at bin/chezmoi"
  rm "bin/chezmoi" || fail "Failed to remove temporary chezmoi binary"
  [[ -z "$(ls -A bin)" ]] && (rmdir "bin" || fail "Failed to remove bin directory")
fi

draw_line
echo "Installation complete 🥳"
echo
echo "To apply changes in current environment, run:"
echo "$ exec zsh -i"
