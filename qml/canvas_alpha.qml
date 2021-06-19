import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
  title: "My Application"
  width: 800
  height: 600
  visible: true

  ColumnLayout {
    id: root
    spacing: 6
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter

      Text {
        text: "Diameter:"
      }

      Slider {
        id: diameter
        width: 100
        value: 50
        from: 5.0
        to: circle_canvas.width
        onValueChanged: {
          parameters.diameter = value;
          circle_canvas.update();
        }
      }

      Text {
        text: "Alpha:"
      }

      Slider {
        id: alpha
        width: 100
        value: 0.5
        from: 0.0
        to: 1.0
        onValueChanged: {
          parameters.alpha = value;
          square_canvas.update();
        }
      }
    }

    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true

      JuliaCanvas {
        anchors.fill: parent
        id: circle_canvas
        paintFunction: circle_cfunction  
      }

      JuliaCanvas {
        anchors.fill: parent
        id: square_canvas
        paintFunction: square_cfunction  
      }
    }
  }
}
