# Use with 'just <target>', e.g. 'just test_and_apply'

_default:
  @just --list

# Chezmoi apply changes if any
test_and_apply:
  mh-chezmoi-test-and-apply

# Git workflows...

alias gw := git_workflow

# Regraft branches
git_workflow:
  mh-git-workflow-rebase-dotfiles

alias gaok := git-absorb-from-ok

git-absorb-from-ok:
  git absorb --base ok --and-rebase

# docker 'play' container based on these dotfiles and mh-install...

play-container-full-build: play-remove-and-purge play-container-update

play-remove-and-purge:
  docker rmi --force play
  # TODO: Use less sledghammer approach, more targetted to play image. Needs to work with update target below, *and* from vscode online, without polluting git status.
  docker system prune --force

play-container-update:
  docker build --platform linux/arm64 -t play -f .devcontainer/Dockerfile --build-arg CACHEBUST="$(date)" .
  # Mainly to remove the previous image
  docker image prune --force
