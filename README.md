# Omarchy Hyperdyne Theme

An *Alien: Romulus* **Hyperdyne Systems** (`PRIVATE TERMINAL 13-231-1`) theme for [Omarchy](https://omarchy.org/).

## Included Elements
- **`theme/`**: Omarchy color palette (`colors.toml`), shell/lock/menu/popup overrides (`shell.toml`), icons, preview, and wallpapers.
- **`fonts/`**: `ShareTechMono-Regular.ttf` (condensed retro-futuristic monospace font).
- **`branding/`**: Custom `HYPERDYNE` block-art logos for the Omarchy About window (`about.txt`) and screensaver (`screensaver.txt`).
- **`terminal/`**:
  - `foot.ini` (`Share Tech Mono` size 11, 18px padding)
  - `starship.toml` (red/amber prompt with `> ` symbol)
  - `hyperdyne-banner.sh` (interactive terminal startup banner)
  - `btop.conf` (square corners, block-style graphs)
- **`plymouth/hyperdyne/`**: Custom Plymouth bootsplash & LUKS unlock theme in `#080201` / `#e44543` / `#da9000` with `Share Tech Mono`.

## Install on Your Omarchy Laptop
```bash
git clone https://github.com/Xkalin1990/omarchy-hyperdyne-theme.git
cd omarchy-hyperdyne-theme
chmod +x install.sh
./install.sh
```
