# Use with 'just <target>', e.g. 'just d'

@default: unmanaged diff

alias a := apply
alias d := diff
alias u := unmanaged

apply *files:
  chezmoi apply {{files}}

diff *files:
  chezmoi diff {{files}}

unmanaged:
  chezmoi unmanaged
