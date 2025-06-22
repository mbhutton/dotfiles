# shellcheck shell=bash

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
    echo -n "Installing or updating $package... "
    npm install -g "$package" \
    || fail "Failed to install or update npm package: $package"
  done

  echo "Updating all global npm packages..."
  npm update -g
}

function doctor_npm {
  echo "npm_doctor"
  # TODO: check for unexpected global packages using 'npm list -g --depth=0'
}