import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
  title: "My Application"
  width: 300
  height: 300
  visible: true

  ColumnLayout {
    spacing: 6
    anchors.centerIn: parent

    Button {
      Layout.alignment: Qt.AlignCenter
      text: "Push Me"
      onClicked: Julia.test_display(jdisp)
    }

    JuliaDisplay {
      id: jdisp
      width: 256
      height: 256
    }
  }
}
