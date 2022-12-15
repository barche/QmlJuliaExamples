import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang
import QtQuick.Window

ApplicationWindow {
  id: appRoot
  title: "Makie Plot"
  width: 500
  height: 500
  visible: true

  onWidthChanged: updates.needupdate = true
  onHeightChanged: updates.needupdate = true

  MakieViewport {
    id: viewport
    anchors.fill: parent
    renderFunction: render_callback

    Component.onCompleted: {
      updates.needupdate = true;
      viewport.update()
    }

    // Show the corner points
    Repeater {
      anchors.fill: parent
      model: positionModel

      Item {
        id: pointDelegate
        width: 9
        height: 9
        
        // The point marker itself
        Rectangle {
          id: pointMarker
          width: 9
          height: 9
          color: "black"

          // Mouse interaction
          MouseArea {
            anchors.fill: parent
            drag.target: pointDelegate
            drag.threshold: 0
            drag.smoothed: false
            hoverEnabled: true
            onPressed: parent.color = "yellow" // visual feedback for the clicking
            onReleased: parent.color = "black"
            onEntered: if (pressedButtons == 0) { parent.color = "green" }
            onExited: if (pressedButtons == 0) { parent.color = "black"; }
            onClicked: details.visible = !details.visible
          }
        }

        // Textfields, shown when clicked
        Rectangle {
          id: details
          x: pointMarker.width
          y: pointMarker.height
          color: "lightgray"
          width: 80
          height: 60
          visible: false

          ColumnLayout {
            spacing: 3
		        anchors.centerIn: parent
            RowLayout {
              spacing: 3
              Layout.fillWidth: true
              Text { text: "x" }

              TextField {
                id: xField
                Layout.preferredWidth: 60
                Layout.preferredHeight: 25
                onAccepted: { xpos = parseFloat(text); updates.needupdate = true; viewport.update(); }
              }
            }
            RowLayout {
              spacing: 3
              Layout.fillWidth: true
              Text { text: "y" }

              TextField {
                id: yField
                Layout.preferredWidth: 60
                Layout.preferredHeight: 25
                onAccepted: { ypos = parseFloat(text); updates.needupdate = true; viewport.update(); }
              }
            }
          }
        }

        // Set initial point positions
        Component.onCompleted: {
          x = xposscreen/Screen.devicePixelRatio - pointMarker.width/2;
          y = appRoot.height - yposscreen/Screen.devicePixelRatio - pointMarker.height/2;
        }

        // Set the x and y position when the points are dragged around
        onXChanged: {
          xposscreen = (x + width/2)*Screen.devicePixelRatio
          xField.text = xpos.toFixed(3)
          viewport.update();
        }
        onYChanged: {
          yposscreen = Screen.devicePixelRatio*(appRoot.height - (y + height/2))
          yField.text = ypos.toFixed(3)
          viewport.update();
        }

        // Adjust point positions when the model was updated, e.g. by window resizing
        Connections {
          target: updates
          function onNeedupdateChanged() {
            x = xposscreen/Screen.devicePixelRatio - pointMarker.width/2;
            y = appRoot.height - yposscreen/Screen.devicePixelRatio - pointMarker.height/2;
          }
        }
      }
    }
  }
}
