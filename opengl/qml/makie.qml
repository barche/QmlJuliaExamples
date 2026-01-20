import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import jlqml

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
        value: 0.0
        from: 0.0
        to: 360.0
        onValueChanged: {
          cat.angle = value;
          viewport.update();
        }
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter
      Text {
        text: (Math.round(angle.value * 100) / 100).toString() + "°"
      }
    }

    MakieViewport {
      id: viewport
      Layout.fillWidth: true
      Layout.fillHeight: true
      renderFunction: render_callback
    }
  }

}
