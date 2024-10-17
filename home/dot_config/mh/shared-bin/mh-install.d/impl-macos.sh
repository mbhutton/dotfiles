# shellcheck shell=bash
#
# include xcode and command line tools
#

if [[ ! /usr/bin/git --version ]]; then
  echo "Installing Xcode Command Line Tools"
  xcode-select --install || fail "Failed to install Xcode Command Line Tools"
fi
