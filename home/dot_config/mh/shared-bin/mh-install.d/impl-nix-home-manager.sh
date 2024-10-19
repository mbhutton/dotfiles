# shellcheck shell=bash

# See home.nix

function noun_for_nix-home-manager {
  echo "Nix Home Manager ❄️"
}

function asserts_for_nix-home-manager {
  echo "asserts_for_nix-home-manager"
}

function install_or_update_nix-home-manager {
  echo "install_or_update_nix-home-manager"
  if [[ "$(uname -s)" == "Linux" ]]; then
    command -v nix-channel >/dev/null 2>&1 || fail "nix-channel command not found. if a devcontainer, add the nix feature."

    # TODO make idempotent, and only do this when installing for first time
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install


    # TODO: only do this when installing for first time
    if [[ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]]; then
      source "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      echo "Nix Home Manager activated"
    else
      echo "WARN: Nix Home Manager still not set up!" >&2
    fi

    # avoid doing work here when nothing updated. ie second quick run should be fast
    home-manager build
    home-manager switch
  fi
}

function doctor_nix-home-manager {
  echo "doctor_nix-home-manager"
}
