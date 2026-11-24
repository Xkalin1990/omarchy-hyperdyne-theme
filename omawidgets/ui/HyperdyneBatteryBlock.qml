import QtQuick
import qs.Commons
import "../model/Format.js" as Format

// Terminal-style battery readout block for Hyperdyne theme (no circular gauge).
Rectangle {
  id: root

  property real fraction: -1
  property bool low: false
  property bool charging: false
  property string remaining: ""
  property string stateLabel: ""
  property real changeRate: 0

  width: parent ? parent.width : implicitWidth
  implicitHeight: col.implicitHeight + Style.space(12)
  color: Util.alpha(HyperdyneTheme.bgDeep, 0.82)
  border.width: 1
  border.color: root.low ? HyperdyneTheme.brightRed : Util.alpha(HyperdyneTheme.muted, 0.65)

  Column {
    id: col
    anchors.fill: parent
    anchors.margins: Style.space(6)
    spacing: Style.spacing.xs

    Row {
      width: parent.width
      spacing: Style.spacing.sm

      Text {
        id: pctText
        textFormat: Text.PlainText
        text: Format.isKnown(root.fraction) ? Format.percent(root.fraction) : "—"
        color: root.low ? HyperdyneTheme.brightRed : HyperdyneTheme.amberBright
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: Style.font.title
        font.bold: true
      }

      Column {
        anchors.verticalCenter: pctText.verticalCenter
        spacing: 1

        Text {
          textFormat: Text.PlainText
          text: root.remaining !== ""
            ? (root.remaining + (root.charging ? " // TO FULL" : " // LEFT"))
            : root.stateLabel.toUpperCase()
          color: root.low ? HyperdyneTheme.brightRed : HyperdyneTheme.amber
          font.family: HyperdyneTheme.fontFamily
          font.pixelSize: Style.font.caption
          font.bold: true
          font.letterSpacing: 0.7
        }

        Text {
          textFormat: Text.PlainText
          visible: root.changeRate > 0.1
          text: (root.charging ? "CHARGE +" : "DRAW −") + Format.watts(root.changeRate)
          color: root.charging ? HyperdyneTheme.gold : HyperdyneTheme.amberDim
          font.family: HyperdyneTheme.fontFamily
          font.pixelSize: Style.font.caption
          font.letterSpacing: 0.6
        }
      }
    }
  }
}
