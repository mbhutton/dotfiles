# Use with 'just <target>', e.g. 'just test_and_apply'

@default: test_and_apply

test_and_apply:
  mh-chezmoi-test-and-apply

alias gw := git_workflow

git_workflow:
  mh-git-workflow-rebase-dotfiles
