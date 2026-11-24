import QtQuick
import qs.Commons
import qs.Ui
import "../ui"

// Chrome shared by every widget card.
//
// Colour, radius, border, type scale and spacing all come from the active
// Omarchy theme's own singletons — the same ones the stock panels read — so a
// theme switch restyles these cards in the same frame as the rest of the shell,
// with nothing to configure and no palette of our own to drift out of step.
BorderSurface {
  id: root

  property string title: ""
  property string glyph: ""
  property string meta: ""
  property bool compact: false
  property bool alert: false
  property bool selected: false
  property bool closable: false
  property bool hovered: false
  property bool arasakaThemed: false
  property bool hyperdyneThemed: true
  property string hudCode: ""
  property string wyCode: ""

  signal closeRequested()
  property real backgroundOpacity: 0.92

  readonly property bool hudActive: arasakaThemed && ArasakaTheme.active
  readonly property bool hyperdyneActive: hyperdyneThemed && HyperdyneTheme.active
  readonly property bool customHud: hudActive || hyperdyneActive
  readonly property real topBandHeight: hyperdyneActive ? Style.space(20) : 0
  readonly property color foreground: hyperdyneActive
    ? HyperdyneTheme.amber
    : (hudActive ? ArasakaTheme.text : Color.popups.text)
  readonly property color dim: hyperdyneActive
    ? HyperdyneTheme.amberDim
    : (hudActive ? ArasakaTheme.textDim : Qt.darker(foreground, 1.45))
  readonly property color accent: hyperdyneActive
    ? (alert ? HyperdyneTheme.brightRed : HyperdyneTheme.red)
    : (hudActive
      ? (alert ? ArasakaTheme.yellow : ArasakaTheme.red)
      : (alert ? Color.urgent : Color.accent))
  readonly property string fontFamily: hyperdyneActive
    ? HyperdyneTheme.fontFamily
    : (hudActive ? ArasakaTheme.fontFamily : Style.font.family)
  readonly property string glyphFontFamily: Style.font.family

  default property alias content: contentColumn.children

  color: Util.alpha(hyperdyneActive
    ? HyperdyneTheme.bg
    : (hudActive ? ArasakaTheme.bg : Color.popups.background), backgroundOpacity)
  radius: customHud ? 0 : Style.cornerRadius
  // Selection is drawn as a flat accent border rather than the theme's own
  // selected-control tokens: some themes give those zero width, and a selection
  // you cannot see is worse than one that does not match the palette exactly.
  borderSpec: hyperdyneActive
    ? Border.flat(selected ? HyperdyneTheme.amber
        : (alert ? HyperdyneTheme.brightRed : Util.alpha(HyperdyneTheme.red, 0.72)),
        selected ? Math.max(2, Style.space(2)) : Math.max(1, Style.space(1)))
    : (hudActive
      ? Border.flat(selected ? ArasakaTheme.red : Util.alpha(ArasakaTheme.red, 0.42),
          selected ? Math.max(2, Style.space(2)) : Math.max(1, Style.space(1)))
      : (selected
        ? Border.flat(Color.accent, Math.max(2, Style.space(2)))
        : Border.surfaceSpec("popups", "border", Color.popups.border, Math.max(1, Style.space(1)))))
  padding: compact ? Style.spacing.popupPadding : Style.spacing.panelPadding

  implicitHeight: contentTopInset + topBandHeight + header.implicitHeight + gap + contentColumn.implicitHeight
    + contentBottomInset

  readonly property real gap: contentColumn.children.length > 0
    ? (compact ? Style.spacing.md : Style.spacing.lg) + (customHud ? Style.space(6) : 0)
    : 0

  ArasakaCardChrome {
    anchors.fill: parent
    visible: root.hudActive
    hudCode: root.hudCode
    hideBadge: root.closable && root.hovered
    z: 0
  }

  HyperdyneCardChrome {
    anchors.fill: parent
    visible: root.hyperdyneActive
    hudCode: root.wyCode !== "" ? root.wyCode : root.hudCode
    bandHeight: root.topBandHeight + Style.space(2)
    hideBadge: root.closable && root.hovered
    alert: root.alert
    z: 0
  }

  Row {
    id: header
    anchors.top: parent.top
    anchors.topMargin: root.contentTopInset + root.topBandHeight
    anchors.left: parent.left
    anchors.leftMargin: root.contentLeftInset
    anchors.right: parent.right
    anchors.rightMargin: root.contentRightInset
    spacing: Style.spacing.md

    Text {
      id: glyphText
      textFormat: Text.PlainText
      visible: root.glyph !== ""
      text: root.glyph
      color: root.accent
      font.family: root.glyphFontFamily
      font.pixelSize: Style.font.icon
      anchors.verticalCenter: titleColumn.verticalCenter
    }

    Column {
      id: titleColumn
      width: parent.width - (glyphText.visible ? glyphText.width + parent.spacing : 0)
      spacing: Style.space(1)

      Text {
        textFormat: Text.PlainText
        width: parent.width
        // Device and model names arrive over Bluetooth and CPU strings come from
        // /proc, so every title is foreign text: PlainText and elided, never
        // interpreted and never allowed to stretch the card.
        text: root.customHud ? root.title.toUpperCase() : root.title
        color: root.foreground
        font.family: root.fontFamily
        font.pixelSize: Style.font.subtitle
        font.bold: true
        font.letterSpacing: root.hyperdyneActive ? 1.5 : (root.hudActive ? 1.4 : 0)
        elide: Text.ElideRight
      }

      Text {
        textFormat: Text.PlainText
        width: parent.width
        visible: root.meta !== ""
        text: root.customHud ? root.meta.toUpperCase() : root.meta
        color: root.hyperdyneActive ? HyperdyneTheme.amberDim
          : (root.hudActive ? ArasakaTheme.textRose : root.dim)
        font.family: root.fontFamily
        font.pixelSize: Style.font.caption
        font.bold: root.customHud
        font.letterSpacing: root.customHud ? 1.1 : 0
        elide: Text.ElideRight
      }
    }
  }

  Image {
    visible: root.customHud && contentColumn.children.length > 0
    anchors.top: header.bottom
    anchors.topMargin: Math.max(4, Math.round(root.gap * 0.35))
    anchors.left: parent.left
    anchors.leftMargin: root.contentLeftInset
    anchors.right: parent.right
    anchors.rightMargin: root.contentRightInset
    height: root.hyperdyneActive ? 4 : 3
    source: root.hyperdyneActive ? "../assets/hyperdyne-divider.svg" : "../assets/hud-divider.svg"
    fillMode: Image.Stretch
  }

  // Hover is tracked with a handler rather than a MouseArea so it never takes
  // the press away from anything inside the widget.
  HoverHandler {
    id: hover
    enabled: root.closable
    onHoveredChanged: root.hovered = hovered
  }

  CloseButton {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: Style.spacing.xs
    z: 20
    shown: root.closable && root.hovered
    onActivated: root.closeRequested()
  }

  Column {
    id: contentColumn
    anchors.top: header.bottom
    anchors.topMargin: root.gap
    anchors.left: parent.left
    anchors.leftMargin: root.contentLeftInset
    anchors.right: parent.right
    anchors.rightMargin: root.contentRightInset
    spacing: root.compact ? Style.spacing.sm : Style.spacing.md
  }
}
