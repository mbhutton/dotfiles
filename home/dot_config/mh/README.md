# 'mh' directory

This directory layout is specific to the ``mbhutton/dotfiles`` setup.

## mh/shared-bin

Contains executables to be included in ``PATH``.

## mh/shell-common

Contains shell files for use by multiple shells,
including bash and zsh.

The files are indented to be sourced directly from
each shell setup as needed, rather than automatically.

They can also be sourced from executables in ``mh/shared-bin``.

All files should be sourced via the ``MH_SHELL_COMMON`` env variable
rather than using relative paths.
