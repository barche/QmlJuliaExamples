import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
  id: root
  title: "Observables"
  width: 512
  height: 200
  visible: true
  onClosing: Qt.quit()

  ColumnLayout {
    spacing: 6
    anchors.fill: parent

    Slider {
      value: observables.input
      Layout.alignment: Qt.AlignCenter
      Layout.fillWidth: true
      from: 0.0
      to: 100.0
      stepSize: 1.0
      onValueChanged: {
        observables.input = value;
        observables.output = 2*observables.input;
      }
    }

    Text {
      Layout.alignment: Qt.AlignCenter
      text: observables.output
      font.pixelSize: 0.1*root.height
    }
  }

}
