#!/bin/bash
set -euo pipefail

THEME_NAME="hyperdyne"

restore_or_remove_file() {
  local target="$1"
  if [[ -f "${target}.bak" ]]; then
    mv -f "${target}.bak" "$target"
  else
    rm -f "$target"
  fi
}

echo "Uninstalling Hyperdyne Omarchy theme..."

# 1. Stop CRT shader watcher and remove Hyprland hooks/files
for pid in $(pgrep -f 'crt-shader-watcher\.sh' || true); do
  kill "$pid" 2>/dev/null || true
done

rm -f "$HOME/.config/hypr/shaders/crt-scanlines.glsl"
rm -f "$HOME/.config/hypr/scripts/crt-shader-watcher.sh"
rm -f "$HOME/.config/hypr/crt-shader-state.lua"

if [[ -f "$HOME/.config/hypr/looknfeel.lua" ]]; then
  sed -i '/crt-shader-state\.lua/d' "$HOME/.config/hypr/looknfeel.lua"
fi

if [[ -f "$HOME/.config/hypr/autostart.lua" ]]; then
  sed -i '/crt-shader-watcher\.sh/d' "$HOME/.config/hypr/autostart.lua"
fi

if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload config-only >/dev/null 2>&1 || true
fi

# 2. Restore terminal, prompt, btop, and bashrc
restore_or_remove_file "$HOME/.config/foot/foot.ini"
restore_or_remove_file "$HOME/.config/starship.toml"
restore_or_remove_file "$HOME/.config/btop/btop.conf"
rm -f "$HOME/.config/omarchy/hyperdyne-banner.sh"

if [[ -f "$HOME/.bashrc" ]]; then
  sed -i '/# Hyperdyne terminal header for interactive shells/,/^fi$/d' "$HOME/.bashrc"
fi

# 3. Restore branding and shell plugins
for f in about.txt screensaver.txt; do
  restore_or_remove_file "$HOME/.config/omarchy/branding/$f"
done

for plugin in omarchy.menu omarchy.bar; do
  dest="$HOME/.config/omarchy/plugins/$plugin"
  rm -rf "$dest"
  if [[ -d "${dest}.bak" ]]; then
    mv -f "${dest}.bak" "$dest"
  fi
done

# 4. Remove theme and font
rm -rf "$HOME/.config/omarchy/themes/$THEME_NAME"
rm -f "$HOME/.local/share/fonts/ShareTechMono-Regular.ttf"
command -v fc-cache >/dev/null 2>&1 && fc-cache -f || true

# 5. Restore Plymouth theme if previously recorded
if [[ -f "$HOME/.config/omarchy/hyperdyne-prev-plymouth" ]] && command -v plymouth-set-default-theme >/dev/null 2>&1; then
  prev_plymouth=$(cat "$HOME/.config/omarchy/hyperdyne-prev-plymouth" || true)
  if [[ -n "$prev_plymouth" ]]; then
    echo "Restoring previous Plymouth theme '$prev_plymouth' (requires sudo)..."
    sudo plymouth-set-default-theme -R "$prev_plymouth" || true
  fi
  rm -f "$HOME/.config/omarchy/hyperdyne-prev-plymouth"
fi

if command -v omarchy >/dev/null 2>&1; then
  omarchy restart shell || true
fi

echo "Hyperdyne theme uninstalled. Switch to another theme with 'omarchy theme set <name>'."
