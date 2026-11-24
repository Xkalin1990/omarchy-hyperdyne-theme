import QtQuick
import qs.Commons

// The headline reading on a full-size card: a ring with the number inside it.
//
// The same full circle the tiles and the pod gauges draw, so a card and a tile
// showing the same reading look like the same reading. IconRing owns the arc;
// this adds the label that goes in the middle of it.
IconRing {
  id: root

  property string text: ""
  property string caption: ""
  property color captionColor: hyperdyneStyle
    ? HyperdyneTheme.amberDim
    : (arasakaStyle ? ArasakaTheme.cyan : Qt.darker(Color.popups.text, 1.45))

  implicitWidth: Style.space(72)
  implicitHeight: implicitWidth
  thickness: Math.max(3, width * 0.085)

  Column {
    anchors.centerIn: parent
    spacing: 0

    Text {
      textFormat: Text.PlainText
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.text
      color: root.hyperdyneStyle ? HyperdyneTheme.amberBright
        : (root.arasakaStyle ? ArasakaTheme.text : Color.popups.text)
      font.family: root.hyperdyneStyle ? HyperdyneTheme.fontFamily
        : (root.arasakaStyle ? ArasakaTheme.fontFamily : Style.font.family)
      font.pixelSize: Style.font.heading
      font.bold: true
    }

    Text {
      textFormat: Text.PlainText
      anchors.horizontalCenter: parent.horizontalCenter
      visible: root.caption !== ""
      text: (root.arasakaStyle || root.hyperdyneStyle) ? root.caption.toUpperCase() : root.caption
      color: root.captionColor
      font.family: root.hyperdyneStyle ? HyperdyneTheme.fontFamily
        : (root.arasakaStyle ? ArasakaTheme.fontFamily : Style.font.family)
      font.pixelSize: Style.font.caption
      font.bold: true
      font.letterSpacing: (root.arasakaStyle || root.hyperdyneStyle) ? 0.8 : 0
    }
  }
}
