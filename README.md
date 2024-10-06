# github.com/mbhutton/dotfiles

Matt Hutton's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Install them and install/upgrade the associated tools with:

- `$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mbhutton --branch dev`
- `$ zsh -i -c mh-install`
- `$ exec zsh -i`

Then keep up to date with:

- (Within zsh): `$ chezmoi update && mh-install && exec zsh -i`

Pre-requisites on Linux:

- `curl`, `bash`, `zsh`, `git`, `sudo`
- POSIX tools such as `awk`, `sed`, `grep`, `find`, `wc`, `xargs` (expected to be built-in)

Pre-requisites on macOS:

Install Xcode Command Line Tools:
`$ xcode-select --install`
