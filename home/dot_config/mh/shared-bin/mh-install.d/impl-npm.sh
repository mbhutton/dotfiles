# shellcheck shell=bash

# TODO: Manager this more explicitly through mise
# TODO: Consolidate mermaid-cli and claude to use the same approach: probably `npm install -g` using latest node via mise

DESIRED_NPM_PACKAGES_PATH="${HOME}/.config/mh/desired-state/npm"

assert_function mh-parse-desired

DESIRED_NPM_PACKAGES=()
if [[ -f "$DESIRED_NPM_PACKAGES_PATH" ]]; then
  while IFS='' read -r line; do DESIRED_NPM_PACKAGES+=("$line"); done < <(mh-parse-desired < "$DESIRED_NPM_PACKAGES_PATH")
fi

function noun_for_npm {
  echo "global npm packages 📦"
}

function asserts_for_npm {
  command -v npm >/dev/null 2>&1 || fail "npm not found"
  command -v node >/dev/null 2>&1 || fail "node not found"
  [[ -f "${DESIRED_NPM_PACKAGES_PATH}" ]] || fail "Desired npm packages file not found: $DESIRED_NPM_PACKAGES_PATH"
}

function install_or_update_npm {
  local package
  echo "Installing or updating global npm packages..." ; echo

  for package in "${DESIRED_NPM_PACKAGES[@]}"; do
    echo "Installing or updating $package... "
    npm install -g "$package" \
    || fail "Failed to install or update npm package: $package"
  done

  # TODO: The install command above should handle updates, making the below redundant.
  # echo "Updating all global npm packages..."
  # npm update -g
}

function doctor_npm {
  true
  # npm doctor TODO: Too verbose for now, would need filtering
  # TODO: check for unexpected global packages using 'npm list -g --depth=0'
  #   npm list -g --depth=0 --parseable=true
  # /Users/matt/.local/share/mise/installs/node/24.2.0/lib
  # /Users/matt/.local/share/mise/installs/node/24.2.0/lib/node_modules/@anthropic-ai/claude-code
  # /Users/matt/.local/share/mise/installs/node/24.2.0/lib/node_modules/corepack
  # /Users/matt/.local/share/mise/installs/node/24.2.0/lib/node_modules/npm
  }
