import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.1
import QtQuick.Window 2.2

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
        text: "Amplitude:"
      }

      Slider {
        id: amplitudeSlider
        width: 100
        value: 1.0
        minimumValue: 0.1
        maximumValue: 5.0
        onValueChanged: { 
          parameters.amplitude = value;
          painter.update()
        }
      }

      Text {
        text: "Frequency:"
      }

      Slider {
        id: frequencySlider
        width: 100
        value: 10.0
        minimumValue: 1.0
        maximumValue: 50.
        onValueChanged: { 
          parameters.frequency = value;
          painter.update()
        }
      }
    }

    JuliaPaintedItem {
      id: painter
      paintFunction : paint_cfunction
      Layout.fillWidth: true
      Layout.fillHeight: true
    }
  }
}
