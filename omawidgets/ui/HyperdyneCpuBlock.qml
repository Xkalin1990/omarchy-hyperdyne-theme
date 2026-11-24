import QtQuick
import qs.Commons
import "../cards"
import "../model/Format.js" as Format

// Terminal-style CPU telemetry block for Hyperdyne theme (no circular gauge).
Rectangle {
  id: root

  property real cpuLoad: -1
  property real cpuTemperature: -1
  property real cpuFrequency: -1
  property real loadOne: -1
  property bool cpuHot: false
  property bool compact: false
  property bool showCoreBars: true
  property var cpuHistory: []
  property var coreLoads: []
  property color fill: HyperdyneTheme.red

  width: parent ? parent.width : implicitWidth
  implicitHeight: col.implicitHeight + Style.space(12)
  color: Util.alpha(HyperdyneTheme.bgDeep, 0.82)
  border.width: 1
  border.color: Util.alpha(HyperdyneTheme.muted, 0.65)

  Column {
    id: col
    anchors.fill: parent
    anchors.margins: Style.space(6)
    spacing: Style.spacing.sm

    Row {
      width: parent.width
      spacing: Style.spacing.sm

      Text {
        id: pctText
        textFormat: Text.PlainText
        text: Format.isKnown(root.cpuLoad) ? Format.percent(root.cpuLoad) : "—"
        color: root.cpuHot ? HyperdyneTheme.brightRed : HyperdyneTheme.amberBright
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: Style.font.heading
        font.bold: true
      }

      Text {
        textFormat: Text.PlainText
        text: Format.isKnown(root.cpuTemperature) ? Format.celsius(root.cpuTemperature) : "CPU"
        color: root.cpuHot ? HyperdyneTheme.brightRed : HyperdyneTheme.red
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: Style.font.caption
        font.bold: true
        anchors.baseline: pctText.baseline
      }
    }

    Text {
      textFormat: Text.PlainText
      width: parent.width
      visible: Format.isKnown(root.cpuFrequency) || Format.isKnown(root.loadOne)
      text: Format.joinMeta([
        Format.isKnown(root.cpuFrequency) ? Format.megahertz(root.cpuFrequency) : "",
        Format.isKnown(root.loadOne) ? "LOAD " + root.loadOne.toFixed(2) : ""
      ], "  //  ")
      color: HyperdyneTheme.amberDim
      font.family: HyperdyneTheme.fontFamily
      font.pixelSize: Style.font.caption
      elide: Text.ElideRight
    }

    HistoryGraph {
      width: parent.width
      height: root.compact ? Style.space(18) : Style.space(22)
      hyperdyneStyle: true
      series: root.cpuHistory
      fill: root.fill
    }

    CoreBars {
      visible: root.showCoreBars
      width: parent.width
      height: Style.space(14)
      hyperdyneStyle: true
      fill: HyperdyneTheme.amber
      loads: root.coreLoads
    }
  }
}
