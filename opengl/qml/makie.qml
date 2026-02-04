import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Makie

ApplicationWindow {
  title: "My Application"
  width: 512
  height: 512
  visible: true

  ColumnLayout {
    id: root
    spacing: 6
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter

      Text {
        text: "Angle:"
      }

      Slider {
        id: angle
        value: cat.angle
        from: 0.0
        to: 360.0
        onMoved: cat.angle = value
        onValueChanged: viewport.update()
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter
      Text {
        text: (Math.round(angle.value * 100) / 100).toString() + "°"
      }
    }

    MakieArea {
      id: viewport
      Layout.fillWidth: true
      Layout.fillHeight: true
      scene: cat.mesh
    }
  }

}
