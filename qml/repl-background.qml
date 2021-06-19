import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
  title: "My Application"
  width: 512
  height: 512
  visible: true

  JuliaDisplay {
    id: jdisp
    anchors.fill: parent

    Component.onCompleted: {
      Julia.pushdisplay(jdisp)
    }
  }
}
