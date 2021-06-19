import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

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
      minimumValue: 0.0
      maximumValue: 100.0
      stepSize: 1.0
      tickmarksEnabled: true
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
