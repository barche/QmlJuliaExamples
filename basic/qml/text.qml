import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
  title: "Text"
  width: 200
  height: 200
  visible: true

  ColumnLayout {
    id: root
    spacing: 6
    anchors.fill: parent

    Text {
      text: fromcontext
    }

    Text {
      text: Julia.fromfunction()
    }
  }
}
