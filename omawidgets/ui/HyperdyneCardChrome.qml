import QtQuick
import qs.Commons

// Hyperdyne / Weyland-Yutani CRT terminal frame overlay:
// - Subtle tiled CRT scanlines across the card surface
// - Recessed top telemetry header band with Weyland-Yutani wing emblem & code
// - Crisp bottom corner reticles
Item {
  id: root

  property string hudCode: ""
  property real bandHeight: 20
  property bool hideBadge: false
  property bool alert: false

  // Subtle CRT scanline texture across card surface
  Image {
    anchors.fill: parent
    anchors.margins: 1
    source: "../assets/hyperdyne-scanline.png"
    fillMode: Image.Tile
    opacity: 0.16
    smooth: false
  }

  // Top telemetry header band
  Rectangle {
    id: topBand
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.margins: 1
    height: root.bandHeight
    color: Util.alpha(HyperdyneTheme.bgHeader, 0.92)

    // Bottom hairline of the telemetry band
    Rectangle {
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 1
      color: root.alert ? HyperdyneTheme.brightRed : Util.alpha(HyperdyneTheme.red, 0.72)
    }

    // Left: Weyland-Yutani wing emblem + module code
    Row {
      anchors.left: parent.left
      anchors.leftMargin: 7
      anchors.verticalCenter: parent.verticalCenter
      spacing: 6

      Image {
        width: 18
        height: 8
        source: "../assets/wy-wing.svg"
        sourceSize.width: 36
        sourceSize.height: 16
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        textFormat: Text.PlainText
        text: root.hudCode !== "" ? ("W-Y // " + root.hudCode) : "W-Y // TERM"
        color: root.alert ? HyperdyneTheme.brightRed : HyperdyneTheme.amber
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: 9
        font.bold: true
        font.letterSpacing: 1.2
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    // Right: Terminal ID + Hyperdyne geometric emblem (hides smoothly on hover for CloseButton)
    Row {
      anchors.right: parent.right
      anchors.rightMargin: 7
      anchors.verticalCenter: parent.verticalCenter
      spacing: 5
      opacity: root.hideBadge ? 0 : 0.78

      Behavior on opacity {
        NumberAnimation { duration: 120 }
      }

      Text {
        textFormat: Text.PlainText
        text: "13-231-1"
        color: HyperdyneTheme.amberDim
        font.family: HyperdyneTheme.fontFamily
        font.pixelSize: 8
        font.letterSpacing: 0.9
        anchors.verticalCenter: parent.verticalCenter
      }

      Image {
        width: 15
        height: 8
        source: "../assets/hyperdyne-emblem.svg"
        sourceSize.width: 30
        sourceSize.height: 16
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }

  // Bottom-left corner reticle (rotated 270 deg)
  Image {
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.margins: 3
    width: 10
    height: 10
    source: "../assets/hyperdyne-corner.svg"
    rotation: 270
    smooth: false
    opacity: 0.85
  }

  // Bottom-right corner reticle (rotated 180 deg)
  Image {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 3
    width: 10
    height: 10
    source: "../assets/hyperdyne-corner.svg"
    rotation: 180
    smooth: false
    opacity: 0.85
  }
}
