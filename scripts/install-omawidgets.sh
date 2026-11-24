#!/usr/bin/env bash
set -euo pipefail

# Works both from a local clone and standalone via:
#   curl -fsSL https://raw.githubusercontent.com/Xkalin1990/omarchy-hyperdyne-theme/main/scripts/install-omawidgets.sh | bash
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
REPO_DIR=""
TMP_DIR=""

if [[ -n "${SCRIPT_PATH}" && -f "${SCRIPT_PATH}" ]]; then
  CANDIDATE="$(cd "$(dirname "${SCRIPT_PATH}")/.." && pwd)"
  if [[ -d "${CANDIDATE}/omawidgets" ]]; then
    REPO_DIR="${CANDIDATE}"
  fi
fi

if [[ -z "${REPO_DIR}" ]]; then
  TMP_DIR="$(mktemp -d)"
  trap 'rm -rf "${TMP_DIR}"' EXIT
  echo "Fetching Hyperdyne / Weyland-Yutani OmaWidgets overlay..."
  git clone --depth 1 https://github.com/Xkalin1990/omarchy-hyperdyne-theme.git "${TMP_DIR}/theme"
  REPO_DIR="${TMP_DIR}/theme"
fi

SRC_DIR="${REPO_DIR}/omawidgets"
CONFIG_DIR="${XDG_CONFIG_HOME:-${HOME}/.config}/omarchy"
PLUGINS_DIR="${CONFIG_DIR}/plugins"
DEST_DIR="${PLUGINS_DIR}/io.github.fabandrade88.omawidgets"
SHELL_JSON="${CONFIG_DIR}/shell.json"
UPSTREAM_REPO="https://github.com/fabandrade88/OmaWidgets.git"

# 1. Install OmaWidgets if missing
if [[ ! -d "${DEST_DIR}" ]]; then
  echo "Installing OmaWidgets plugin to ${DEST_DIR}..."
  mkdir -p "${PLUGINS_DIR}"
  git clone "${UPSTREAM_REPO}" "${DEST_DIR}"
fi

# 2. Apply Hyperdyne / Weyland-Yutani card files & CRT/vector assets
echo "Applying Hyperdyne / Weyland-Yutani CRT card styling..."
mkdir -p "${DEST_DIR}/assets" "${DEST_DIR}/cards" "${DEST_DIR}/ui"
cp "${SRC_DIR}/assets/"* "${DEST_DIR}/assets/"
cp "${SRC_DIR}/cards/"* "${DEST_DIR}/cards/"
cp "${SRC_DIR}/ui/"* "${DEST_DIR}/ui/"

# 3. Auto-enable desktop cards in ~/.config/omarchy/shell.json if not already configured
if [[ -f "${SHELL_JSON}" ]] && command -v python3 >/dev/null 2>&1; then
  if ! grep -q '"io.github.fabandrade88.omawidgets"' "${SHELL_JSON}"; then
    BACKUP="${SHELL_JSON}.bak.$(date +%s)"
    cp "${SHELL_JSON}" "${BACKUP}"
    echo "Backing up ${SHELL_JSON} to ${BACKUP} and enabling OmaWidgets desktop cards..."
    python3 - "${SHELL_JSON}" <<'PY'
import json, sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

layout = data.setdefault("bar", {}).setdefault("layout", {})
left = layout.setdefault("left", [])
left.append({
    "id": "io.github.fabandrade88.omawidgets",
    "desktop": True,
    "position": "top-left",
    "marginX": 28,
    "marginY": 20,
    "cardWidth": 268,
    "spacing": 10,
    "columns": 1,
    "opacity": 0.92,
    "compact": False,
    "grid": False,
    "cards": ["system", "battery", "power", "media", "pods"],
})

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
  fi
fi

# 4. Restart Omarchy shell so new singletons and assets take effect immediately
if command -v omarchy >/dev/null 2>&1; then
  echo "Restarting Omarchy shell..."
  omarchy restart shell || true
fi

echo "Done! Hyperdyne / Weyland-Yutani cards are ready (active whenever 'hyperdyne' theme is selected)."
