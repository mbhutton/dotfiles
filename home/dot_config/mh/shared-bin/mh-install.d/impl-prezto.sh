# shellcheck shell=bash

# Installs or updates mbhutton prezto fork

# TODO:how to set this in bash
ZDOTDIR="$HOME/.config/zsh"


github_protocol_and_domain="https://github.com/"
prezto_fork="mbhutton/prezto.git"
repo_url="${github_protocol_and_domain}${prezto_fork}"
target_dir="${ZDOTDIR}/.zprezto"
symlink_to_repo="${HOME}/git/1-core/prezto"

ensure_symlink_or_fail() {
  local target_path="$1"
  local symlink_path="$2"

  [[ -d "$symlink_path" && ! -L "$symlink_path" ]] && echo "Desired symlink at $symlink_path already exists as a directory" && return 1
  [[ -f "$symlink_path" && ! -L "$symlink_path" ]] && echo "Desired symlink at $symlink_path already exists as a file" && return 1

  if [[ -L "$symlink_path" ]]; then
    echo "Checking that symlink at $symlink_path points to $target_path..."
    local existing_target
    existing_target="$(readlink "$symlink_path")"
    if [[ "$existing_target" != "$target_path" ]]; then
      echo "Symlink at $symlink_path points to $existing_target, not $target_path"
      return 1
    fi
  else
    echo "Creating symlink at $symlink_path pointing to $target_path..."
    mkdir -p "$(dirname "$symlink_path")" || { echo "Failed to ensure parent dir of symlink at $symlink_path exists"; return 1; }
    ln -s "$target_path" "$symlink_path" || { echo "Failed to create symlink at $symlink_path pointing to $target_path"; return 1; }
  fi
}

function noun_for_prezto {
  echo "Prezto (for Zsh)  🐚"
}

function asserts_for_prezto {
  [[ -n "${ZDOTDIR:-}" ]] || fail "ZDOTDIR not set"
  [[ -d "${ZDOTDIR}" ]] || fail "ZDOTDIR does not exist or is not a directory"
}

function install_or_update_prezto {
  if [[ ! -d "${ZDOTDIR}/.zprezto" ]]; then
    echo "Cloning prezto to from repo $repo_url to $target_dir..."
    git clone --recursive "$repo_url" "$target_dir" \
      || fail "Failed to git clone prezto to $target_dir"
  else
   git -C "$target_dir" pull origin \
     || fail "Failed to git fetch prezto repo at $target_dir"
  fi

  ensure_symlink_or_fail "$target_dir" "$symlink_to_repo" \
    || fail "Failed to ensure symlink at $symlink_to_repo points to $target_dir"

  git -C "$target_dir" submodule update --init --recursive
}

function doctor_prezto {
  echo "Checking prezto..."
  # TODO
}
