# Notes on design goals and choices

## Dependency tree

DAG for depedendencies

bootstrap pre: curl, sh, bash, apt (if linux)
Bootstrap fetches: chezmoi-temp
Chezmoi apply ensures: brew (mac), zsh (prefer system) (use XDG locations ), git (prefer system), rustup/cargo (ensuring my CARGO_HOME and RUSTUP_HOME), mise,atuin,bat,broot,fd,delta,hyperfine,just,ripgrep,starship(cargo), , python(mise), uv, go(mise), go install(mise), fzf,chezmoi,lazy,shfmt*(go mise), other non-(go|rust|python) packages, uv (py git up)

Use brew on macOS and Linux x86



## Targets

### macOS Docker target

Go: Use golang internally ( mise) to go install and update all tools. No copying or caching.
Use go install <package@latest style>

Rust: probably start with same approach, though for base dev image, start with these packages already cargo installed via dockerfile . If it's annoying to wait during updates , look at caching the final binaries, perhaps using the (updated) clean image itself as the cache.

Base container should have a command to cat a tar file of all the rust binaries (and maybe go binaries) , for easy copying out from the host . ?

Consider homebrew managed other files like shell integrations

Base container to use apt to get other packages

## Package access

As

## Goals

Quality : shellcheck strict and tests: with linting of sources and targets too
 Shell test defaulting to bash, and always checking for double quotes
Bash and Zsh

* Zsh as target shell, with ergonomic setup and preferred dev tooling
* Bash as secondary target:
  ** Enough settings to not clash with zsh
  ** Enough settings to work as a fallback if zsh ever broken or not available
  ** Integrate with at least mise and atuin and ?
Fast : ideally keep below 0.3s


Chezmoi unmanaged empty
Pull in old config
Cover updates and reports
Boostrappable
Usable in third party codespaces and containers too
Lighter alternative profiles for use in codespaces etc


