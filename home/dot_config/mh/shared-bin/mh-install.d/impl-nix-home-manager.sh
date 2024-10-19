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
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager \
      || fail "Failed to add home-manager channel"
    nix-channel --update || fail "Failed to update channels"
    nix-shell '<home-manager>' -A install || fail "Failed to install home-manager"
    source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" || fail "Failed to source home-manager session vars"
  fi

  command -v nix-channel >/dev/null 2>&1 || fail "nix-channel command not found"

  nix-channel --update  # TODO: how many of this and build and switch are required each time?
  # avoid doing work here when nothing updated. ie second quick run should be fast
  home-manager build
  home-manager switch
  # TODO: maybe remove the nix 'result' file, or see if possible to not create it in the first place
}

function doctor_nix-home-manager {
  echo "doctor_nix-home-manager"
}
