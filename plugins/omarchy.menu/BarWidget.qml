import QtQuick
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.menu"

  implicitWidth: 34
  implicitHeight: bar ? bar.thickness : 26

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: ""
    onPressed: function(button) {
      if (!root.bar) return
      if (button === Qt.RightButton) root.bar.run("xdg-terminal-exec")
      else root.bar.run("omarchy-shell shell toggle omarchy.menu '{\"menu\":\"root\"}'")
    }

    Image {
      anchors.centerIn: parent
      source: Qt.resolvedUrl("wy-logo.svg")
      width: 24
      height: 11
      fillMode: Image.PreserveAspectFit
      smooth: true
    }
  }
}
