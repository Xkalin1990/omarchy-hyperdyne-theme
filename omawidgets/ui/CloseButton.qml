import QtQuick
import qs.Commons
import qs.Ui

// The small X that appears on a widget when you hover it.
//
// Hiding lives on the widget itself rather than behind a keybind: there is
// nothing to discover, nothing to configure, and no chance of colliding with a
// binding Omarchy already uses.
BorderSurface {
  id: root

  property bool shown: false

  signal activated()

  readonly property bool hyperdyneActive: HyperdyneTheme.active
  readonly property bool customHud: hyperdyneActive || ArasakaTheme.active
  readonly property real diameter: Math.max(Style.space(18), Style.font.body + Style.spacing.xs)

  width: diameter
  height: diameter
  radius: customHud ? 0 : diameter / 2
  color: hyperdyneActive
    ? (mouse.containsMouse ? HyperdyneTheme.red : Util.alpha(HyperdyneTheme.bgDeep, 0.94))
    : (mouse.containsMouse
      ? Color.urgent
      : Util.alpha(Color.popups.background, 0.92))
  borderSpec: hyperdyneActive
    ? Border.flat(mouse.containsMouse ? HyperdyneTheme.amber : HyperdyneTheme.red, 1)
    : Border.flat(mouse.containsMouse ? Color.urgent
      : Util.alpha(Color.popups.text, 0.35), 1)

  // Fades rather than appearing, so a pointer crossing the desktop does not
  // make every widget flicker a button.
  opacity: shown ? 1 : 0
  visible: opacity > 0
  Behavior on opacity { NumberAnimation { duration: 120 } }

  Text {
    anchors.centerIn: parent
    textFormat: Text.PlainText
    text: "󰅖"
    color: root.hyperdyneActive
      ? (mouse.containsMouse ? HyperdyneTheme.bgDeep : HyperdyneTheme.amber)
      : (mouse.containsMouse ? Color.popups.background : Color.popups.text)
    font.family: Style.font.family
    font.pixelSize: root.diameter * 0.62
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    // Takes the press so the tap underneath never sees it: clicking the X
    // should hide the widget, not select it.
    onClicked: root.activated()
  }
}
