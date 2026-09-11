#!/bin/bash

# Allow key repeats for Vim motions in apps with a Vim mode,
# e.g. to support holing down `j` to move the cursor down multiple lines.

# Only continue if macOS
[[ "$(uname -s)" == "Darwin" ]] || exit 0

IDE_LIST=(
  "com.jetbrains.cwm.guest"
  "com.jetbrains.CLion"
  "com.jetbrains.intellij.ce"
  "com.jetbrains.pycharm"
  "com.jetbrains.rubymine"
  "com.jetbrains.rustrover"
  "com.jetbrains.WebStorm"
  "com.microsoft.VSCode"
  "com.microsoft.VSCodeInsiders"
  "com.todesktop.230313mzl4w4u92" # Cursor
)

for IDE in "${IDE_LIST[@]}"; do
  defaults write "$IDE" ApplePressAndHoldEnabled -bool false
done
