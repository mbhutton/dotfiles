# github.com/mbhutton/dotfiles

Matt Hutton's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Includes configuration and automated installation and upgrading for lots of development tools.

These are for my own use to bootstrap, sync and update development environments on new machines.
Feel free to use them as a reference or starting point for your own dotfiles.

## Bootstrap on Linux

- Prerequisites: `bash`, `curl`, `sudo`
- Run: `$ bash -c "$(curl -fsLS https://raw.githubusercontent.com/mbhutton/dotfiles/refs/heads/dev/bootstrap/install-for-linux.sh)"`

## Bootstrap on macOS

- Install Xcode Command Line Tools if necessary: `$ xcode-select --install`
- `$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mbhutton --branch dev`
- `$ zsh -i -c mh-install`
- `$ exec zsh -i`

## Keep up to date

- (Within zsh): `$ chezmoi update && mh-install && exec zsh -i`
