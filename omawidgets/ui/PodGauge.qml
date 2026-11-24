import QtQuick
import qs.Commons

// One pod, or the case: a ring with its mark inside and the level underneath.
// The unit the AirPods card and the AirPods tile are both built from.
Item {
  id: root

  property string kind: "left"
  property var pod: null
  property real ringSize: Style.space(46)
  property bool showLevel: true
  property bool hyperdyneStyle: false

  readonly property int level: pod ? pod.level : -1
  readonly property bool known: level >= 0
  readonly property bool charging: !!pod && pod.charging === true
  readonly property bool inEar: !!pod && pod.inEar === true
  readonly property bool low: known && level <= 20 && !charging

  readonly property color accent: hyperdyneStyle
    ? (low ? HyperdyneTheme.brightRed : (charging ? HyperdyneTheme.gold : HyperdyneTheme.red))
    : (low ? Color.urgent : Color.accent)
  // An absent pod keeps its place in the row, drawn as an empty ring, so the
  // layout does not reshuffle when one is taken out of the case.
  readonly property color markColor: hyperdyneStyle
    ? (known ? HyperdyneTheme.amber : Util.alpha(HyperdyneTheme.amberDim, 0.35))
    : (known ? Color.popups.text : Util.alpha(Color.popups.text, 0.35))

  implicitWidth: hyperdyneStyle ? Style.space(68) : Math.max(ringSize, levelText.implicitWidth)
  implicitHeight: hyperdyneStyle
    ? termCol.implicitHeight + Style.space(8)
    : (ringSize + (showLevel ? levelText.implicitHeight + Style.spacing.xs : 0))

  // Terminal-style pod readout (no circular ring)
  Rectangle {
    visible: root.hyperdyneStyle
    anchors.fill: parent
    anchors.margins: 2
    color: Util.alpha(HyperdyneTheme.bgDeep, 0.82)
    border.width: 1
    border.color: root.low ? HyperdyneTheme.brightRed : Util.alpha(HyperdyneTheme.muted, 0.6)

    Column {
      id: termCol
      anchors.centerIn: parent
      width: parent.width - Style.space(10)
      spacing: Style.spacing.xs

      Text {
        textFormat: Text.PlainText
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.kind.toUpperCase() + (root.charging ? " [+]" : "")
        color: HyperdyneTheme.amberDim
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: Style.font.caption
        font.bold: true
        font.letterSpacing: 0.8
      }

      Text {
        textFormat: Text.PlainText
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.known ? root.level + "%" : "—"
        color: root.low ? HyperdyneTheme.brightRed : HyperdyneTheme.amberBright
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: Style.font.subtitle
        font.bold: true
      }

      MeterBar {
        width: parent.width
        hyperdyneStyle: true
        value: root.known ? root.level / 100 : -1
        fill: root.accent
      }
    }
  }

  IconRing {
    id: ring
    visible: !root.hyperdyneStyle
    anchors.horizontalCenter: parent.horizontalCenter
    width: root.ringSize
    height: root.ringSize
    value: root.known ? root.level / 100 : -1
    fill: root.accent
    charging: root.charging

    PodMark {
      anchors.centerIn: parent
      kind: root.kind
      color: root.markColor
      cutout: Color.popups.background
      size: parent.width
    }
  }

  Text {
    id: levelText
    textFormat: Text.PlainText
    visible: root.showLevel && !root.hyperdyneStyle
    anchors.top: ring.bottom
    anchors.topMargin: Style.spacing.xs
    anchors.horizontalCenter: parent.horizontalCenter
    text: root.known ? root.level + "%" : "—"
    color: root.low ? Color.urgent : Color.popups.text
    font.family: Style.font.family
    font.pixelSize: Style.font.subtitle
    font.bold: true
  }
}
