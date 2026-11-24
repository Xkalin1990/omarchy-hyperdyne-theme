import QtQuick
import qs.Commons
import qs.Ui
import "../model/Power.js" as Power

// Saver / Balanced / Performance, as one segmented control.
//
// Only the profiles the running daemon actually reported get a segment, so a
// machine without power-profiles-daemon shows an explanatory line instead of
// three buttons that would do nothing. Every click goes back through
// PowerService.setProfile, which re-checks the name against the allowlist.
Item {
  id: root

  property var profiles: []
  property string active: ""
  property bool busy: false
  property int cursorIndex: -1
  property bool arasakaStyle: false
  property bool hyperdyneStyle: false

  signal selected(string profile)

  readonly property bool customHud: arasakaStyle || hyperdyneStyle
  readonly property color foreground: hyperdyneStyle
    ? HyperdyneTheme.amber
    : (arasakaStyle ? ArasakaTheme.text : Color.popups.text)
  readonly property color dim: hyperdyneStyle
    ? HyperdyneTheme.amberDim
    : (arasakaStyle ? ArasakaTheme.textDim : Qt.darker(foreground, 1.45))
  readonly property string fontFamily: hyperdyneStyle
    ? HyperdyneTheme.fontFamily
    : (arasakaStyle ? ArasakaTheme.fontFamily : Style.font.family)

  visible: profiles.length > 0
  width: parent ? parent.width : implicitWidth
  implicitHeight: row.implicitHeight

  Row {
    id: row
    width: parent.width
    spacing: Style.spacing.xs

    Repeater {
      model: root.profiles

      BorderSurface {
        id: segment

        readonly property bool isActive: modelData === root.active
        readonly property bool hasCursor: index === root.cursorIndex
        readonly property bool hot: mouse.containsMouse || hasCursor

        width: (root.width - Style.spacing.xs * Math.max(0, root.profiles.length - 1))
          / Math.max(1, root.profiles.length)
        implicitHeight: Math.max(Style.spacing.controlHeight, label.implicitHeight + Style.spacing.md * 2)
        radius: root.customHud ? 0 : Style.cornerRadius
        color: root.hyperdyneStyle
          ? (isActive ? HyperdyneTheme.selection
            : (hot ? HyperdyneTheme.bgHeader : Util.alpha(HyperdyneTheme.bgDeep, 0.72)))
          : (root.arasakaStyle
            ? (isActive ? ArasakaTheme.selection
              : (hot ? ArasakaTheme.bgMuted : Util.alpha(ArasakaTheme.bgDeep, 0.55)))
            : (isActive ? Style.selectedAccentFill : (hot ? Style.hoverFill : Style.normalFill)))
        borderSpec: root.hyperdyneStyle
          ? Border.flat(isActive ? HyperdyneTheme.red
            : (hot ? HyperdyneTheme.amberDim : Util.alpha(HyperdyneTheme.muted, 0.55)), 1)
          : (root.arasakaStyle
            ? Border.flat(isActive ? ArasakaTheme.red
              : (hot ? ArasakaTheme.crimson : Util.alpha(ArasakaTheme.crimson, 0.35)), 1)
            : Border.controlSpec(isActive ? "selected" : (hot ? "hover" : "normal"),
              root.foreground, Color.accent, Color.urgent))
        opacity: root.busy ? 0.6 : 1

        // Crisp bottom accent bar on active tactical button
        Rectangle {
          visible: root.customHud && segment.isActive
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          height: 2
          color: root.hyperdyneStyle ? HyperdyneTheme.red : ArasakaTheme.red
        }

        Column {
          id: label
          anchors.centerIn: parent
          spacing: Style.space(1)

          Text {
            textFormat: Text.PlainText
            anchors.horizontalCenter: parent.horizontalCenter
            text: Power.profileIcon(modelData)
            color: root.hyperdyneStyle
              ? (segment.isActive ? HyperdyneTheme.amberBright
                : (segment.hot ? HyperdyneTheme.amber : HyperdyneTheme.amberDim))
              : (root.arasakaStyle
                ? (segment.isActive ? ArasakaTheme.cyan
                  : (segment.hot ? ArasakaTheme.text : ArasakaTheme.textDim))
                : (segment.isActive ? Color.accent : (segment.hot ? root.foreground : root.dim)))
            font.family: root.arasakaStyle ? ArasakaTheme.fontFamily : Style.font.family
            font.pixelSize: Style.font.icon
          }

          Text {
            textFormat: Text.PlainText
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.customHud
              ? Power.profileLabel(modelData).toUpperCase()
              : Power.profileLabel(modelData)
            color: segment.isActive ? root.foreground : root.dim
            font.family: root.fontFamily
            font.pixelSize: Style.font.caption
            font.bold: segment.isActive
            font.letterSpacing: root.customHud ? 0.7 : 0
          }
        }

        MouseArea {
          id: mouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          enabled: !root.busy
          onClicked: root.selected(modelData)
        }
      }
    }
  }
}
