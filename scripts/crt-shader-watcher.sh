#!/usr/bin/env bash
set -uo pipefail

SHADER_PATH="${HOME}/.config/hypr/shaders/crt-scanlines.glsl"
STATE_FILE="${HOME}/.config/hypr/crt-shader-state.lua"
SOCK="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"
LAST_STATE=""

# Apply CRT shader when the active workspace contains solely system/terminal windows
should_enable_shader() {
  local ws_id classes
  ws_id=$(hyprctl activeworkspace -j 2>/dev/null | jq -r '.id // empty')
  [[ -n "${ws_id}" ]] || return 1

  classes=$(hyprctl clients -j 2>/dev/null | jq -r --argjson ws "${ws_id}" '
    [.[] | select(.workspace.id == $ws and .mapped == true) | .class] | .[]
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
  cat > "${STATE_FILE}" <<LUA
hl.config({
  decoration = {
    screen_shader = "${val}",
  },
})
LUA
  hyprctl reload config-only >/dev/null 2>&1 || true
}

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
      write_state "${SHADER_PATH}"
    else
      write_state "[[EMPTY]]"
    fi
  fi
}

sync_shader

socat -u "UNIX-CONNECT:${SOCK}" - 2>/dev/null | while IFS= read -r line; do
  case "${line}" in
    activewindow\>\>*|workspace\>\>*|focusedmon\>\>*|openwindow\>\>*|closewindow\>\>*|movewindow\>\>*)
      sync_shader
      ;;
  esac
done
