# Use with 'just <target>', e.g. 'just test_and_apply'

_default:
  @just --list

# Chezmoi apply changes if any
test_and_apply:
  mh-chezmoi-test-and-apply

bu_ok:
  git rev-parse --quiet --verify ok >/dev/null && git branch -f bu-ok ok && git push -f -u origin bu-ok

alias gw := git_workflow

# Regraft branches
git_workflow:
  mh-git-workflow-rebase-dotfiles
