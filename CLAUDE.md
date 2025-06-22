# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is Matt Hutton's dotfiles repository managed with [chezmoi](https://github.com/twpayne/chezmoi). It provides automated configuration and installation for development tools across macOS and Linux environments.

## Core Commands

### Testing and Applying Changes
- `just test_and_apply` - Test and apply chezmoi changes (uses `mh-chezmoi-test-and-apply`)
- `just lint` - Run comprehensive linting checks
- `chezmoi apply` - Apply configuration changes
- `chezmoi diff` - See pending changes

### Installation and Updates
- `mh-install` - Install all components based on desired state configuration
- `mh-install <component>` - Install specific component(s)
- `chezmoi update && mh-install && exec zsh -i` - Full system update

### Git Workflows
- `just git_workflow` - Rebase branches using git workflow
- `just git-absorb-from-ok` - Absorb changes from 'ok' branch

## Architecture

### Directory Structure
- `home/` - Contains all dotfiles and configurations that will be installed to `$HOME`
- `home/dot_config/mh/` - Custom tooling and configuration
  - `shared-bin/` - Executables added to PATH
  - `shell-common/` - Shell files for cross-shell compatibility  
  - `desired-state/` - Component installation configuration
- `bootstrap/` - Bootstrap scripts for new environments

### Component System
The `mh-install` system uses a component-based approach:
- Components are defined in `home/dot_config/mh/desired-state/components.tmpl`
- Each component has an implementation in `home/dot_config/mh/shared-bin/mh-install.d/impl-<component>.sh`
- Installation order is significant and handles dependencies
- Supports both macOS (Homebrew) and Linux (APT/Nix) package managers

### Templating
Uses chezmoi templating with `.tmpl` extensions for platform-specific configurations. Template variables include:
- `.mh.isMacOS` / `.mh.isLinux` - Platform detection
- `.mh.hasMacAppStore` - macOS App Store availability
- `.mh.useAeroSpace` - AeroSpace window manager usage

### Linting
The `run_lints` script performs comprehensive validation:
- Python code linting with `ruff`, `pyrefly`, and `ty`
- Shell script validation with `shellcheck`
- Spell checking with `cspell`
- Checks for unmanaged files in chezmoi

### Shell Configuration
- Primary shell: zsh with Prezto framework
- Modular configuration in `home/dot_config/zsh/zshrc.d/`
- Custom aliases for chezmoi operations (e.g., `cz=chezmoi`, `czz=mh-chezmoi-test-and-apply`)
- Shared utilities in `mh/shell-common/` for cross-shell compatibility

### Key Tools and Frameworks
- **chezmoi** - Dotfiles management
- **just** - Command runner (justfile)
- **Prezto** - Zsh framework
- **Starship** - Shell prompt
- **mise** - Runtime version management
- **jj** - Jujutsu version control (alongside git)