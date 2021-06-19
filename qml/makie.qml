import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

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
        minimumValue: 0.0
        maximumValue: 360.0
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
