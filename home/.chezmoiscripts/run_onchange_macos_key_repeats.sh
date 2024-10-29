#!/bin/bash

# Allow key repeats for Vim motions in VSCode and JetBrains IDEs,
# e.g. to support holing down `j` to move the cursor down multiple lines.

# Only continue if macOS
[[ "$(uname -s)" == "Darwin" ]] || exit 0

IDE_LIST=(
  "com.jetbrains.cwm.guest"
  "com.jetbrains.intellij.ce"
  "com.jetbrains.intellij"
  "com.jetbrains.pycharm.ce"
  "com.jetbrains.pycharm"
  "com.microsoft.VSCode"
)

for IDE in "${IDE_LIST[@]}"; do
  defaults write "$IDE" ApplePressAndHoldEnabled -bool false
done
