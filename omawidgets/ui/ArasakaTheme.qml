pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Live watcher for the active Omarchy theme name so Arasaka HUD styling
// activates only when "arasaka-corp" is selected and reverts cleanly on any
// other theme.
QtObject {
  id: root

  readonly property string stateHome: Quickshell.env("XDG_STATE_HOME")
    || (Quickshell.env("HOME") + "/.local/state")
  readonly property string themeNamePath: stateHome + "/omarchy/current/theme.name"

  property string themeName: ""
  readonly property bool active: themeName === "arasaka-corp"

  // Arasaka-Corp palette (mirrors ~/.config/omarchy/themes/arasaka-corp/colors.toml)
  readonly property color bg: "#14101F"
  readonly property color bgDeep: "#040A10"
  readonly property color bgMuted: "#331319"
  readonly property color selection: "#5A1A22"
  readonly property color crimson: "#B81D24"
  readonly property color red: "#FB3048"
  readonly property color cyan: "#5DF4FE"
  readonly property color teal: "#1AC5B0"
  readonly property color green: "#28C775"
  readonly property color yellow: "#FDF500"
  readonly property color text: "#FCFCFC"
  readonly property color textRose: "#D85C60"
  readonly property color textDim: "#A1A9B1"
  readonly property string fontFamily: "JetBrainsMono Nerd Font"

  property FileView themeFile: FileView {
    path: root.themeNamePath
    watchChanges: true
    onLoaded: root.themeName = String(text() || "").trim()
    onFileChanged: reload()
  }
}
