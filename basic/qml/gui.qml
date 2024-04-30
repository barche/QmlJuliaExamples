import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
    title: "My Application"
    width: 480
    height: 640
    visible: true

    SystemPalette { id: syscolors; colorGroup: SystemPalette.Active }

    Connections {
      target: guiproperties.timer
      function onTimeout() { Julia.counter_slot(); }
    }

    ColumnLayout {
      spacing: 6
      anchors.centerIn: parent

      Text {
          id: juliaHello
          Layout.alignment: Qt.AlignCenter
          text: Julia.hello()
          color: syscolors.text
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Push Me"
          onClicked: { resultDisplay.text = Julia.increment_counter().toString(); }
      }

      Text {
          id: resultDisplay
          Layout.alignment: Qt.AlignCenter
          text: "Push button for result"
          color: syscolors.text
      }

      TextField {
          id: lowerIn
          Layout.alignment: Qt.AlignCenter
          Layout.minimumWidth: 300
          placeholderText: qsTr("Start typing, Julia does the rest...")
      }

      Text {
          id: upperOut
          Layout.alignment: Qt.AlignCenter
          text: Julia.uppercase(lowerIn.text)
          color: syscolors.text
      }

      Text {
          Layout.alignment: Qt.AlignCenter
          text: "Concatenation, showing multiple arguments:"
          color: syscolors.text
      }

      Text {
          Layout.alignment: Qt.AlignCenter
          text: Julia.string(guiproperties.oldcounter, ", ", upperOut.text)
          color: syscolors.text
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Start counting"
          onClicked: guiproperties.timer.start()
      }

      Text {
          Layout.alignment: Qt.AlignCenter
          text: guiproperties.bg_counter.toString()
          color: syscolors.text
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Stop counting"
          onClicked: guiproperties.timer.stop()
      }
  }
}
