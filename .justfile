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

lint:
  ./lints/lint_readme
  ./lints/lint_zsh

test:
  # TODO
