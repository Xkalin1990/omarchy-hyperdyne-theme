import QtQuick
import qs.Commons
import "../ui"

// One labelled reading with its own meter: "CPU   32%  45°" over a fill bar.
Item {
  id: root

  property string label: ""
  property string value: ""
  property string detail: ""
  property real fraction: -1
  property bool alert: false
  property bool showMeter: true
  property bool arasakaStyle: false
  property bool hyperdyneStyle: false
  property color accentColor: Color.accent

  readonly property color foreground: hyperdyneStyle
    ? HyperdyneTheme.amber
    : (arasakaStyle ? ArasakaTheme.text : Color.popups.text)
  readonly property color dim: hyperdyneStyle
    ? HyperdyneTheme.amberDim
    : (arasakaStyle ? ArasakaTheme.textDim : Qt.darker(foreground, 1.45))
  readonly property color fill: alert
    ? (hyperdyneStyle ? HyperdyneTheme.brightRed : (arasakaStyle ? ArasakaTheme.red : Color.urgent))
    : accentColor
  readonly property string fontFamily: hyperdyneStyle
    ? HyperdyneTheme.fontFamily
    : (arasakaStyle ? ArasakaTheme.fontFamily : Style.font.family)

  width: parent ? parent.width : implicitWidth
  implicitHeight: labelRow.implicitHeight + (showMeter ? meter.implicitHeight + Style.spacing.xs : 0)

  Row {
    id: labelRow
    width: parent.width
    spacing: Style.spacing.sm

    Text {
      id: labelText
      textFormat: Text.PlainText
      text: root.label
      color: root.hyperdyneStyle ? HyperdyneTheme.amberDim
        : (root.arasakaStyle ? ArasakaTheme.textRose : root.dim)
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      font.bold: true
      font.letterSpacing: (root.arasakaStyle || root.hyperdyneStyle) ? 0.9 : 0
    }

    Item {
      width: Math.max(0, parent.width - labelText.width - valueText.width - detailText.width
        - parent.spacing * (detailText.visible ? 2 : 1))
      height: 1
    }

    Text {
      id: detailText
      textFormat: Text.PlainText
      visible: root.detail !== ""
      text: root.detail
      color: root.hyperdyneStyle ? HyperdyneTheme.amberDim
        : (root.arasakaStyle ? ArasakaTheme.cyan : root.dim)
      font.family: root.fontFamily
      font.pixelSize: Style.font.bodySmall
      anchors.baseline: valueText.baseline
    }

    Text {
      id: valueText
      textFormat: Text.PlainText
      text: root.value
      color: root.alert
        ? (root.hyperdyneStyle ? HyperdyneTheme.brightRed : (root.arasakaStyle ? ArasakaTheme.red : Color.urgent))
        : (root.hyperdyneStyle ? HyperdyneTheme.amberBright : root.foreground)
      font.family: root.fontFamily
      font.pixelSize: Style.font.body
      font.bold: true
    }
  }

  MeterBar {
    id: meter
    visible: root.showMeter
    anchors.top: labelRow.bottom
    anchors.topMargin: Style.spacing.xs
    anchors.left: parent.left
    anchors.right: parent.right
    arasakaStyle: root.arasakaStyle
    hyperdyneStyle: root.hyperdyneStyle
    value: root.fraction
    fill: root.fill
  }
}
