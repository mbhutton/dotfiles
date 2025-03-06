# shellcheck shell=bash

UPDATER_SCRIPT="$HOME/.config/aerospace/mh-update-aerospace-config"

function is_aerospace_running {
  pgrep -x AeroSpace >/dev/null
}

function noun_for_aerospace {
  echo "AeroSpace 🪐"
}

function asserts_for_aerospace {
  command -v aerospace > /dev/null || fail "AeroSpace is not installed or not in PATH"
  command -v uv > /dev/null || fail "'uv' is not installed or not in PATH"
  [[ -f "$UPDATER_SCRIPT" ]] || fail "AeroSpace config updater script not found at: $UPDATER_SCRIPT"
}

function install_or_update_aerospace {
  "$UPDATER_SCRIPT" || fail "Failed to apply AeroSpace config"

  # Ensure AeroSpace is running then reload config
  if ! is_aerospace_running; then
    TOTAL_WAIT_SECONDS=2 # Plus pgrep and sleep overhead which are not accounted for
    RETRY_INTERVAL=0.05
    RETRY_COUNT=$(echo "scale=0; $TOTAL_WAIT_SECONDS / $RETRY_INTERVAL" | bc -l)
    echo "Starting AeroSpace"
    open -a AeroSpace || fail "Failed to start AeroSpace"

    echo "Waiting for AeroSpace to start for up to $TOTAL_WAIT_SECONDS seconds"
    for ((i=1; i<=RETRY_COUNT; i++)); do
      if is_aerospace_running; then
        echo "AeroSpace is running"
        # Add grace period between process start and server availability
        sleep 0.05
        break
      fi
      echo "Waiting $RETRY_INTERVAL seconds as attempt $i of $RETRY_COUNT"
      sleep "$RETRY_INTERVAL"
    done
  fi
  if is_aerospace_running; then
    echo "Reloading AeroSpace config"
    aerospace reload-config || fail "Failed to reload AeroSpace config"
  else
    fail "AeroSpace failed to start in time"
  fi
}

function doctor_aerospace {
  TARGET_DIR="$HOME/.config/aerospace"
  [[ -f "$TARGET_DIR/mh-aerospace-template.toml" ]] || fail "AeroSpace template not found"
  [[ -f "$TARGET_DIR/aerospace.toml" ]] || fail "AeroSpace config not found"
  is_aerospace_running || fail "AeroSpace is not running"
  aerospace list-workspaces --focused >/dev/null || fail "AeroSpace failed to respond to a test command"
}

