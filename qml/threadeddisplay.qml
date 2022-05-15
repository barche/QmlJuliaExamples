import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

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
    }
  }

  Timer {
    // Set interval in ms:
    interval: 40; running: displayCheck.checked; repeat: true
    onTriggered: {
      Julia.showlatest(jdisp);
    }
  }
}
