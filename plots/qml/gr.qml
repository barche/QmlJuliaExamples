import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang
import QtQuick.Window

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
        from: 0.1
        to: 5.0
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
        from: 1.0
        to: 50.0
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
