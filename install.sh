#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_NAME="hyperdyne"

echo "Installing Hyperdyne Omarchy theme..."

# 1. Install Omarchy theme
mkdir -p "$HOME/.config/omarchy/themes/$THEME_NAME"
cp -r "$SCRIPT_DIR/theme/." "$HOME/.config/omarchy/themes/$THEME_NAME/"

# 2. Install Share Tech Mono font
mkdir -p "$HOME/.local/share/fonts"
cp "$SCRIPT_DIR/fonts/ShareTechMono-Regular.ttf" "$HOME/.local/share/fonts/"
fc-cache -f
omarchy font set "Share Tech Mono"

# 3. Install branding (About & Screensaver) and CRT-styled shell plugins
mkdir -p "$HOME/.config/omarchy/branding" "$HOME/.config/omarchy/plugins"
for f in about.txt screensaver.txt; do
  [[ -f "$HOME/.config/omarchy/branding/$f" ]] && cp "$HOME/.config/omarchy/branding/$f" "$HOME/.config/omarchy/branding/$f.bak"
  cp "$SCRIPT_DIR/branding/$f" "$HOME/.config/omarchy/branding/$f"
done
for plugin in omarchy.menu omarchy.bar; do
  if [[ -d "$SCRIPT_DIR/plugins/$plugin" ]]; then
    cp -r "$SCRIPT_DIR/plugins/$plugin" "$HOME/.config/omarchy/plugins/"
  fi
done

# 4. Install CRT shader & terminal-scoped Hyprland shader watcher
mkdir -p "$HOME/.config/hypr/shaders" "$HOME/.config/hypr/scripts"
cp "$SCRIPT_DIR/shaders/crt-scanlines.glsl" "$HOME/.config/hypr/shaders/crt-scanlines.glsl"
cp "$SCRIPT_DIR/scripts/crt-shader-watcher.sh" "$HOME/.config/hypr/scripts/crt-shader-watcher.sh"
chmod +x "$HOME/.config/hypr/scripts/crt-shader-watcher.sh"

if [[ ! -f "$HOME/.config/hypr/crt-shader-state.lua" ]]; then
  cat > "$HOME/.config/hypr/crt-shader-state.lua" <<'LUA'
hl.config({
  decoration = {
    screen_shader = "[[EMPTY]]",
  },
})
LUA
fi

if [[ -f "$HOME/.config/hypr/looknfeel.lua" ]] && ! grep -q "crt-shader-state.lua" "$HOME/.config/hypr/looknfeel.lua"; then
  printf '\npcall(dofile, os.getenv("HOME") .. "/.config/hypr/crt-shader-state.lua")\n' >> "$HOME/.config/hypr/looknfeel.lua"
fi

if [[ -f "$HOME/.config/hypr/autostart.lua" ]] && ! grep -q "crt-shader-watcher.sh" "$HOME/.config/hypr/autostart.lua"; then
  printf '\no.launch_on_start("%s/.config/hypr/scripts/crt-shader-watcher.sh")\n' "$HOME" >> "$HOME/.config/hypr/autostart.lua"
fi

# 5. Install terminal, prompt, and btop styling
mkdir -p "$HOME/.config/foot" "$HOME/.config/btop"
[[ -f "$HOME/.config/foot/foot.ini" ]] && cp "$HOME/.config/foot/foot.ini" "$HOME/.config/foot/foot.ini.bak"
cp "$SCRIPT_DIR/terminal/foot.ini" "$HOME/.config/foot/foot.ini"

[[ -f "$HOME/.config/starship.toml" ]] && cp "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak"
cp "$SCRIPT_DIR/terminal/starship.toml" "$HOME/.config/starship.toml"

[[ -f "$HOME/.config/btop/btop.conf" ]] && cp "$SCRIPT_DIR/terminal/btop.conf" "$HOME/.config/btop/btop.conf"

cp "$SCRIPT_DIR/terminal/hyperdyne-banner.sh" "$HOME/.config/omarchy/hyperdyne-banner.sh"
chmod +x "$HOME/.config/omarchy/hyperdyne-banner.sh"

if ! grep -q "hyperdyne-banner.sh" "$HOME/.bashrc" 2>/dev/null; then
  cat >> "$HOME/.bashrc" <<'EOF'

# Hyperdyne terminal header for interactive shells
if [[ -t 1 && -f "$HOME/.config/omarchy/hyperdyne-banner.sh" ]]; then
  source "$HOME/.config/omarchy/hyperdyne-banner.sh"
fi
EOF
fi

# 6. Apply Omarchy theme and restart shell / shader watcher
omarchy theme set "$THEME_NAME"
omarchy restart shell || true

if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  for pid in $(pgrep -f '^bash .*/crt-shader-watcher\.sh$' || true); do
    kill "$pid" 2>/dev/null || true
  done
  setsid -f "$HOME/.config/hypr/scripts/crt-shader-watcher.sh" >/dev/null 2>&1 || true
fi

# 7. Install Plymouth bootsplash theme (optional, requires sudo)
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
  echo "Installing Hyperdyne Plymouth bootsplash theme (requires sudo)..."
  sudo mkdir -p /usr/share/plymouth/themes/hyperdyne
  sudo cp -r "$SCRIPT_DIR/plymouth/hyperdyne/." /usr/share/plymouth/themes/hyperdyne/
  sudo plymouth-set-default-theme -R hyperdyne
else
  echo "Plymouth not installed; skipping bootsplash. Install with 'sudo pacman -S plymouth' and re-run to enable."
fi

echo "Done! Open a new terminal window to see the Hyperdyne styling."
