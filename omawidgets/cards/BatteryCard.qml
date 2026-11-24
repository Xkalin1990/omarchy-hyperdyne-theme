import QtQuick
import qs.Commons
import "../ui"
import "../model/Format.js" as Format
import "../model/Power.js" as Power

// Battery level, what it is doing, and how long that leaves.
Card {
  id: root

  property var power: null
  property var config: ({})

  // Guarded accessors, for the moment during a hot-reload when the service is
  // gone but the card has not been torn down yet.
  readonly property bool present: !!power && power.present
  readonly property real fraction: power ? power.fraction : Format.UNKNOWN
  readonly property bool charging: !!power && power.charging
  readonly property bool fullyCharged: !!power && power.fullyCharged
  readonly property bool discharging: !!power && power.discharging
  readonly property bool low: !!power && power.low
  readonly property real changeRate: power ? power.changeRate : 0
  readonly property int cycles: power ? power.cycles : 0
  readonly property real healthPercent: power ? power.healthPercent : 0
  readonly property string remaining: Format.duration(power ? power.secondsRemaining : 0)

  // "Charging" / "On battery" / "Fully charged" / "On AC". UPower reports
  // pending-charge on a machine holding at a charge threshold, which is neither
  // charging nor discharging, so it gets its own words rather than a guess.
  readonly property string stateLabel: {
    if (!present) return "No battery"
    if (fullyCharged) return "Fully charged"
    if (charging) return "Charging"
    if (discharging) return "On battery"
    return "On AC"
  }

  arasakaThemed: true
  hyperdyneThemed: true
  hudCode: "PWR"
  wyCode: "PWR-02"
  title: "Battery"
  glyph: power ? power.icon : ""
  alert: low
  meta: Format.joinMeta([
    stateLabel,
    Power.healthLabel(healthPercent),
    cycles > 0 ? cycles + " cycles" : ""
  ])

  // Hyperdyne terminal-style battery readout (no circular gauge)
  HyperdyneBatteryBlock {
    visible: root.present && root.hyperdyneActive
    fraction: root.fraction
    low: root.low
    charging: root.charging
    remaining: root.remaining
    stateLabel: root.stateLabel
    changeRate: root.changeRate
  }

  // Stock & Arasaka RingGauge layout
  Row {
    width: parent.width
    spacing: root.hudActive ? Style.space(14) : Style.spacing.lg
    visible: root.present && !root.hyperdyneActive

    RingGauge {
      id: gauge
      width: root.compact ? Style.space(58) : Style.space(72)
      height: width
      arasakaStyle: root.hudActive
      value: root.fraction
      fill: root.hudActive
        ? (root.low ? ArasakaTheme.red
          : (root.charging ? ArasakaTheme.green : ArasakaTheme.crimson))
        : (root.low ? Color.urgent : Color.accent)
      text: Format.isKnown(root.fraction) ? Format.percent(root.fraction) : "—"
      caption: root.charging ? "charging" : (root.remaining !== "" ? "left" : "battery")
      captionColor: root.hudActive
        ? (root.charging ? ArasakaTheme.green : ArasakaTheme.cyan)
        : Qt.darker(Color.popups.text, 1.45)
    }

    Column {
      width: parent.width - gauge.width - parent.spacing
      spacing: root.hudActive ? Style.space(3) : Style.spacing.sm
      anchors.verticalCenter: gauge.verticalCenter

      Text {
        textFormat: Text.PlainText
        width: parent.width
        // The headline is the answer to "how long have I got", so it is the time
        // estimate when there is one and the state when there is not.
        text: root.remaining !== "" ? root.remaining : root.stateLabel
        color: root.low ? (root.hudActive ? ArasakaTheme.red : Color.urgent) : root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.title
        font.bold: true
        elide: Text.ElideRight
      }

      Text {
        textFormat: Text.PlainText
        width: parent.width
        visible: root.remaining !== ""
        text: root.hudActive
          ? (root.charging ? "UNTIL FULL" : "REMAINING")
          : (root.charging ? "until full" : "of use remaining")
        color: root.dim
        font.family: root.fontFamily
        font.pixelSize: Style.font.caption
        font.bold: root.hudActive
        font.letterSpacing: root.hudActive ? 1.0 : 0
        elide: Text.ElideRight
      }

      Row {
        width: parent.width
        visible: root.changeRate > 0.1
        spacing: Style.space(6)

        Text {
          textFormat: Text.PlainText
          visible: root.hudActive
          text: root.charging ? "CHARGE" : "DRAW"
          color: ArasakaTheme.textRose
          font.family: root.fontFamily
          font.pixelSize: Style.font.caption
          font.bold: true
          font.letterSpacing: 0.9
          anchors.baseline: rateValue.baseline
        }

        Text {
          id: rateValue
          textFormat: Text.PlainText
          text: (root.charging ? "+" : "−") + Format.watts(root.changeRate)
          color: root.hudActive
            ? (root.charging ? ArasakaTheme.green : ArasakaTheme.cyan)
            : root.dim
          font.family: root.fontFamily
          font.pixelSize: Style.font.bodySmall
          font.bold: true
        }
      }
    }
  }

  Item {
    visible: root.present && root.customHud
    width: parent.width
    height: Style.space(2)
  }

  MeterBar {
    visible: root.present
    width: parent.width
    arasakaStyle: root.hudActive
    hyperdyneStyle: root.hyperdyneActive
    value: root.fraction
    fill: root.hyperdyneActive
      ? (root.low ? HyperdyneTheme.brightRed
        : (root.charging ? HyperdyneTheme.gold : HyperdyneTheme.red))
      : (root.hudActive
        ? (root.low ? ArasakaTheme.red
          : (root.charging ? ArasakaTheme.green : ArasakaTheme.red))
        : (root.low ? Color.urgent : Color.accent))
  }

  Text {
    textFormat: Text.PlainText
    width: parent.width
    visible: !root.present
    text: "This machine reports no battery. UPower sees only mains power."
    color: Qt.darker(root.foreground, 1.45)
    font.family: root.fontFamily
    font.pixelSize: Style.font.bodySmall
    wrapMode: Text.WordWrap
  }
}
