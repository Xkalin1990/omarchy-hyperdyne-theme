pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Live watcher for the active Omarchy theme name so Hyperdyne / Weyland-Yutani
// CRT styling activates only when "hyperdyne" is selected and reverts cleanly
// on any other theme.
QtObject {
  id: root

  readonly property string stateHome: Quickshell.env("XDG_STATE_HOME")
    || (Quickshell.env("HOME") + "/.local/state")
  readonly property string themeNamePath: stateHome + "/omarchy/current/theme.name"

  property string themeName: ""
  readonly property bool active: themeName === "hyperdyne"

  // Hyperdyne / Weyland-Yutani CRT palette (mirrors theme/colors.toml)
  readonly property color bg: "#1a0806"
  readonly property color bgDeep: "#0e0403"
  readonly property color bgHeader: "#2b0f0c"
  readonly property color selection: "#3b1512"
  readonly property color red: "#d9463e"
  readonly property color brightRed: "#f25c54"
  readonly property color amber: "#f0a850"
  readonly property color amberBright: "#ffd08a"
  readonly property color amberDim: "#c47d38"
  readonly property color orange: "#e06d44"
  readonly property color gold: "#d98c3e"
  readonly property color muted: "#8a3a35"
  readonly property string fontFamily: "Share Tech Mono"

  property FileView themeFile: FileView {
    path: root.themeNamePath
    watchChanges: true
    onLoaded: root.themeName = String(text() || "").trim()
    onFileChanged: reload()
  }
}
