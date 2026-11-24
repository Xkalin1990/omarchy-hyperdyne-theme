#!/usr/bin/env bash
set -uo pipefail

SHADER_PATH="${HOME}/.config/hypr/shaders/crt-scanlines.glsl"
STATE_FILE="${HOME}/.config/hypr/crt-shader-state.lua"
RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
HYPR_SIG="${HYPRLAND_INSTANCE_SIGNATURE:-}"
LOCK_FILE="${RUNTIME_DIR}/hyperdyne-crt-watcher.lock"
LAST_STATE=""

if [[ -z "${HYPR_SIG}" ]]; then
  echo "crt-shader-watcher: HYPRLAND_INSTANCE_SIGNATURE is not set" >&2
  exit 1
fi

for cmd in hyprctl jq socat flock; do
  if ! command -v "${cmd}" >/dev/null 2>&1; then
    echo "crt-shader-watcher: missing required command '${cmd}'" >&2
    exit 1
  fi
done

SOCK="${RUNTIME_DIR}/hypr/${HYPR_SIG}/.socket2.sock"

# Ensure only one watcher instance runs per user session
exec 9>"${LOCK_FILE}"
if ! flock -n 9; then
  exit 0
fi

# Apply CRT shader when the active workspace contains solely system/terminal windows
should_enable_shader() {
  local ws_id clients_json classes
  ws_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty')
  [[ -n "${ws_id}" ]] || return 1

  clients_json=$(hyprctl clients -j 2>/dev/null) || return 1
  [[ -n "${clients_json}" ]] || return 1

  classes=$(printf '%s' "${clients_json}" | jq -r --argjson ws "${ws_id}" '
    [.[] | select(.workspace.id == $ws and .mapped == true) | (.class // "")] | .[]
  ')

  # Empty workspace (desktop / bar / omarchy shell only) -> enable
  if [[ -z "${classes}" ]]; then
    return 0
  fi

  local cls
  while IFS= read -r cls; do
    case "${cls}" in
      foot|footclient|org.omarchy.*|Alacritty|kitty|com.mitchellh.ghostty|ghostty|org.wezfurlong.wezterm|wezterm|rio|contour|xterm|UXTerm|URxvt|st|st-256color|terminator|tilix|konsole|gnome-terminal*|Tabby|warp*|Hyper|blackbox*)
        ;;
      *)
        return 1
        ;;
    esac
  done <<< "${classes}"

  return 0
}

write_state() {
  local val="$1"
  local dmg="$2"
  local tmp_file
  tmp_file=$(mktemp "${STATE_FILE}.XXXXXX") || return 1
  cat > "${tmp_file}" <<LUA
hl.config({
  decoration = {
    screen_shader = "${val}",
  },
  debug = {
    damage_tracking = ${dmg},
  },
})
LUA
  mv -f "${tmp_file}" "${STATE_FILE}"
  hyprctl reload config-only >/dev/null 2>&1 || true
}

cleanup() {
  write_state "[[EMPTY]]" 2
}
trap cleanup EXIT INT TERM

sync_shader() {
  local target_state
  if should_enable_shader; then
    target_state="on"
  else
    target_state="off"
  fi

  if [[ "${target_state}" != "${LAST_STATE}" ]]; then
    LAST_STATE="${target_state}"
    if [[ "${target_state}" == "on" ]]; then
      write_state "${SHADER_PATH}" 0
    else
      write_state "[[EMPTY]]" 2
    fi
  fi
}

sync_shader

while true; do
  if [[ -S "${SOCK}" ]]; then
    socat -u "UNIX-CONNECT:${SOCK}" - 2>/dev/null | while IFS= read -r line; do
      case "${line}" in
        activewindow\>\>*|workspace\>\>*|focusedmon\>\>*|openwindow\>\>*|closewindow\>\>*|movewindow\>\>*)
          sync_shader
          ;;
      esac
    done
  fi
  sleep 1
done
