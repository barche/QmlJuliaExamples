import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

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
