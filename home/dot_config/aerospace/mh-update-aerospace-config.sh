#!/bin/bash

# Updates AeroSpace configuration based on the AeroSpace config template
# plus programmatic transformations.
#
# Transformation steps are currently a no-op.

fail() {
  echo "$*" >&2
  exit 1
}

command -v uv >/dev/null 2>&1 || fail "uv is not installed or not in PATH"

echo "Re-generating AeroSpace configuration based on template"
SOURCE_TEMPLATE="$HOME/.config/aerospace/mh-aerospace-template.toml"
TARGET_CONFIG="$HOME/.config/aerospace/aerospace.toml"
cp "$SOURCE_TEMPLATE" "$TARGET_CONFIG"
