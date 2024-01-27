# shellcheck shell=bash

# See home.nix

function noun_for_nix-home-manager {
  echo "Nix Home Manager ❄️"
}

function asserts_for_nix-home-manager {
  echo "asserts_for_nix-home-manager"
}

function install_or_update_nix-home-manager {
  if [[ "$(uname -s)" != "Linux" ]]; then
    return 0
  fi

  if [[ ! -d /nix ]]; then
    echo "Installing Nix in single user mode, with /nix owned by current user ($USER) (sudo)"
    sudo mkdir /nix || fail "Failed to create /nix directory"
    sudo chown "$USER:$USER" /nix || fail "Failed to change ownership of /nix directory"
    sh <(curl -L https://nixos.org/nix/install) --no-daemon --yes || fail "Failed to install Nix"
    source "$HOME/.nix-profile/etc/profile.d/nix.sh" || fail "Failed to source Nix profile"

    echo "Installing Home Manager"
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager \
      || fail "Failed to add home-manager channel"
    nix-channel --update || fail "Failed to update channels"
    nix-shell '<home-manager>' -A install || fail "Failed to install home-manager"
    echo "Activating Home Manager"
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" || fail "Failed to source home-manager session vars"

  else
    command -v nix-channel >/dev/null 2>&1 || fail "nix-channel command not found"
    echo "Updating Nix channels"
    nix-channel --update || fail "Failed to update channels"
  fi

  echo "Building and activating Home Manager configuration"
  home-manager switch || fail "Failed to build and activate home-manager configuration"
  if [[ -L result && "$(readlink -f result)" =~ /nix/store/.*-home-manager-generation ]]; then
    echo "Tidying up unnecessary 'result' symlink"
    rm result || echo "Failed to remove 'result' symlink (continuing)" >&2
  fi
}

function doctor_nix-home-manager {
  echo "doctor_nix-home-manager"
}
