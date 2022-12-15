import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
  id: app
  title: "My Application"
  width: 800
  height: 600
  visible: true

  RowLayout {
    id: root
    spacing: 6
    anchors.fill: parent
    Layout.alignment: Qt.AlignCenter

    ColumnLayout {
      Layout.alignment: Qt.AlignCenter

      RowLayout {
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
      }

      JuliaCanvas {
        id: circle_canvas
        paintFunction: circle_cfunction
        Layout.fillWidth: true
        Layout.fillHeight: true
      }

    }

    ColumnLayout {
      Layout.alignment: Qt.AlignCenter
    
      RowLayout {
        Layout.alignment: Qt.AlignCenter
        
        Text {
          text: "Side:"
        }

        Slider {
          id: side
          width: 100
          value: 10.0
          from: 5.0
          to: square_canvas.width
          onValueChanged: {
            parameters.side = value;
            square_canvas.update();
          }
        }
      }

      JuliaCanvas {
        id: square_canvas
        paintFunction: square_cfunction
        Layout.fillWidth: true
        Layout.fillHeight: true
      }

    }
  }
}
