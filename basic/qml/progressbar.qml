import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
  title: "My Application"
  width: 480
  height: 200
  visible: true

  // Set up timer connection
  Connections {
    target: timer
    function onTimeout() { parameters.ticks += 1; }
  }

  ColumnLayout {
    spacing: 6
    anchors.centerIn: parent

    ComboBox {
      Layout.alignment: Qt.AlignCenter
      currentIndex: parameters.selectedSimType-1
      textRole: "display"
      model: simulationTypes
      width: 300
      onCurrentIndexChanged: { if (currentIndex >= 0) { parameters.selectedSimType = currentIndex+1; }}
    }

    RowLayout {
      Layout.alignment: Qt.AlignCenter
      Text { text: "Step size (ms)" }
      Slider {
        from: 0
        value: parameters.stepsize
        stepSize: 1
        to: 100
        onValueChanged: parameters.stepsize = value
      }
      Text { text: parameters.stepsize }
    }

    ProgressBar {
      Layout.alignment: Qt.AlignCenter
      value: parameters.progress
    }

    Button {
      Layout.alignment: Qt.AlignCenter
      text: "Start simulation"
      onClicked: {
        Julia.startsimulation()
      }
    }

    Button {
      Layout.alignment: Qt.AlignCenter
      text: "Stop simulation"
      onClicked: timer.stop();
    }
    Text {
      text: parameters.ticks
    }
  }
}
