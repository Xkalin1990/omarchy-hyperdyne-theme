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

# 3. Install branding (About & Screensaver) and bar menu plugin
mkdir -p "$HOME/.config/omarchy/branding" "$HOME/.config/omarchy/plugins"
for f in about.txt screensaver.txt; do
  [[ -f "$HOME/.config/omarchy/branding/$f" ]] && cp "$HOME/.config/omarchy/branding/$f" "$HOME/.config/omarchy/branding/$f.bak"
  cp "$SCRIPT_DIR/branding/$f" "$HOME/.config/omarchy/branding/$f"
done
if [[ -d "$SCRIPT_DIR/plugins/omarchy.menu" ]]; then
  cp -r "$SCRIPT_DIR/plugins/omarchy.menu" "$HOME/.config/omarchy/plugins/"
fi

# 4. Install terminal, prompt, and btop styling
mkdir -p "$HOME/.config/foot" "$HOME/.config/btop"
[[ -f "$HOME/.config/foot/foot.ini" ]] && cp "$HOME/.config/foot/foot.ini" "$HOME/.config/foot/foot.ini.bak"
cp "$SCRIPT_DIR/terminal/foot.ini" "$HOME/.config/foot/foot.ini"

[[ -f "$HOME/.config/starship.toml" ]] && cp "$HOME/.config/starship.toml" "$HOME/.config/starship.toml.bak"
cp "$SCRIPT_DIR/terminal/starship.toml" "$HOME/.config/starship.toml"

[[ -f "$HOME/.config/btop/btop.conf" ]] && cp "$HOME/.config/btop/btop.conf" "$HOME/.config/btop/btop.conf.bak"
cp "$SCRIPT_DIR/terminal/btop.conf" "$HOME/.config/btop/btop.conf"

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

# 5. Apply Omarchy theme
omarchy theme set "$THEME_NAME"

# 6. Install Plymouth bootsplash theme (optional, requires sudo)
if command -v plymouth-set-default-theme >/dev/null 2>&1; then
  echo "Installing Hyperdyne Plymouth bootsplash theme (requires sudo)..."
  sudo mkdir -p /usr/share/plymouth/themes/hyperdyne
  sudo cp -r "$SCRIPT_DIR/plymouth/hyperdyne/." /usr/share/plymouth/themes/hyperdyne/
  sudo plymouth-set-default-theme -R hyperdyne
else
  echo "Plymouth not installed; skipping bootsplash. Install with 'sudo pacman -S plymouth' and re-run to enable."
fi

echo "Done! Open a new terminal window to see the Hyperdyne styling."
