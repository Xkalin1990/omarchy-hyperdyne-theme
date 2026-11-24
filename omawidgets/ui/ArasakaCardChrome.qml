import QtQuick

// Subtle Arasaka HUD frame overlay: corner brackets and a small corporate
// watermark crest. Drawn behind card text so it never interferes with legibility.
Item {
  id: root

  property string hudCode: ""
  property bool hideBadge: false

  // Top-left bracket
  Image {
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.margins: 3
    width: 12
    height: 12
    source: "../assets/hud-corner.svg"
    smooth: false
    opacity: 0.9
  }

  // Bottom-right bracket (rotated 180 deg)
  Image {
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.margins: 3
    width: 12
    height: 12
    source: "../assets/hud-corner.svg"
    rotation: 180
    smooth: false
    opacity: 0.9
  }

  // Subtle top-right corporate tag + crest
  Row {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.topMargin: 5
    anchors.rightMargin: 7
    spacing: 4
    opacity: root.hideBadge ? 0 : 0.65

    Behavior on opacity {
      NumberAnimation { duration: 120 }
    }

    Text {
      textFormat: Text.PlainText
      visible: root.hudCode !== ""
      text: "ARASAKA // " + root.hudCode
      color: ArasakaTheme.textRose
      font.family: ArasakaTheme.fontFamily
      font.pixelSize: 8
      font.bold: true
      font.letterSpacing: 1.1
      anchors.verticalCenter: parent.verticalCenter
    }

    Image {
      width: 12
      height: 12
      source: "../assets/arasaka-crest.svg"
      sourceSize.width: 24
      sourceSize.height: 24
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
