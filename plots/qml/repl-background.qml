import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import jlqml

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

    onWidthChanged: Julia.setsize(width, height)
    onHeightChanged: Julia.setsize(width, height)
  }
}
