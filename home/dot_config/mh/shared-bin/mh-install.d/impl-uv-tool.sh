# shellcheck shell=bash

DESIRED_UV_TOOLS_PATH="${HOME}/.config/mh/desired-state/uv-tools"

assert_function mh-parse-desired

DESIRED_UV_TOOLS=()
if [[ -f "$DESIRED_UV_TOOLS_PATH" ]]; then
  while IFS='' read -r line; do DESIRED_UV_TOOLS+=("$line"); done < <(mh-parse-desired < "$DESIRED_UV_TOOLS_PATH")
fi

function noun_for_uv-tool {
  echo "global Python packages via uv-tool 🐍"
}

function asserts_for_uv-tool {
  command -v uv >/dev/null 2>&1 || fail "uv not found"
  [[ -n "${UV_TOOL_BIN_DIR:-}" ]] || fail "UV_TOOL_BIN_DIR not set"
  [[ -d "${UV_TOOL_BIN_DIR}" ]] || fail "UV_TOOL_BIN_DIR does not exist or is not a directory"
  [[ -n "${UV_PYTHON:-}" ]] || fail "UV_PYTHON not set"
  [[ -x "${UV_PYTHON}" ]] || fail "UV_PYTHON not executable"
  [[ -f "${DESIRED_UV_TOOLS_PATH}" ]] || fail "Desired uv tools file not found: $DESIRED_UV_TOOLS_PATH"
}

function install_or_update_uv-tool {
  local package
  echo "Installing or updating packages via 'uv tool'..." ; echo
  for package in "${DESIRED_UV_TOOLS[@]}"; do
    echo -n "Installing or updating $package... "
    uv tool install --refresh "$package"
  done

  # TODO: sort out
  # NOTE_SWITCH_SRC_DIR="/Users/matt/git/2-forge/linkshift"
  # [[ -d "$NOTE_SWITCH_SRC_DIR" ]] || fail "NOTE_SWITCH_SRC_DIR does not exist: $NOTE_SWITCH_SRC_DIR"
  # uv tool install --reinstall "$NOTE_SWITCH_SRC_DIR"

  echo "Upgrading all uv tools as necessary..." # Catch any tools not listed above
  uv tool upgrade --all
}

function doctor_uv-tool {
  echo "uv-tool_doctor"
  # TODO: also show unxpected and missing tools
}
