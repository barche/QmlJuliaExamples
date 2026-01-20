import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import jlqml

ApplicationWindow {
  title: "My Application"
  width: 520
  height: 560
  visible: true

  ColumnLayout {
    spacing: 6
    anchors.centerIn: parent

    CheckBox {
      Layout.alignment: Qt.AlignCenter
      id: displayCheck
      text: "Update display"
      checked: false
    }

    JuliaDisplay {
      id: jdisp
      width: 512
      height: 512
      Component.onCompleted: {
        Julia.showlatest(jdisp);
      }
    }
  }

  Timer {
    // Set interval in ms:
    interval: 16; running: displayCheck.checked; repeat: true
    onTriggered: {
      Julia.showlatest(jdisp);
    }
  }
}
