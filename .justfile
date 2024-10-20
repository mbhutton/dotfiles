# Use with 'just <target>', e.g. 'just test_and_apply'

_default:
  @just --list

# Chezmoi apply changes if any
test_and_apply:
  mh-chezmoi-test-and-apply

alias gw := git_workflow

# Regraft branches
git_workflow:
  mh-git-workflow-rebase-dotfiles

alias gaok := git-absorb-from-ok

git-absorb-from-ok:
  git absorb --base ok --and-rebase

play-container-full-build:
  docker build --no-cache --platform linux/arm64 -t play -f .devcontainer/Dockerfile --build-arg CACHEBUST="$(date)" .
  docker image prune --force

play-container-update:
  docker build --platform linux/arm64 -t play -f .devcontainer/Dockerfile --build-arg CACHEBUST="$(date)" .
  docker image prune --force
