import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
  id: appRoot
  title: "Arrays"
  width: 300
  height: 300
  visible: true

  Grid { // arrange items in a grid
    id: grid
    columns: cols // from Julia
    width: appRoot.width
    height: appRoot.height
    
    Repeater { // Repeat for each emoji
      model: emojiModel

      Rectangle { // Each emoji is a rectangle with text in the center
        width: appRoot.width/cols
        height: appRoot.height/cols
        color: bgcolor // from emoji state
        Text {
          anchors.centerIn: parent
          font.pixelSize: 0.75*appRoot.width/cols
          text: emoji // from emoji state
        }

        MouseArea {
          anchors.fill: parent
          onClicked: numclicks += 1 // updates the clicks on the Julia side
          onPressed: parent.color = "white" // visual feedback for the clicking
          onReleased: parent.color = bgcolor
        }
      }
    }
  }
}
