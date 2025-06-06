# Use with 'just <target>', e.g. 'just test_and_apply'

_default:
  @just --list

# Chezmoi apply changes if any
test_and_apply:
  mh-chezmoi-test-and-apply

lint:
  @./run_lints

# Git workflows...

alias gw := git_workflow

# Re-graft branches
git_workflow:
  mh-git-workflow-rebase-dotfiles

alias gaok := git-absorb-from-ok

git-absorb-from-ok:
  git absorb --base ok --and-rebase
