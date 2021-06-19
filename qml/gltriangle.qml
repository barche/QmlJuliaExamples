import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import org.julialang 1.1
import QtQuick.Window 2.2

ApplicationWindow {
  id: appRoot
  title: "OpenGL"
  width: 500
  height: 500
  visible: true

  OpenGLViewport {
    id: viewport
    anchors.fill: parent
    renderFunction: render_triangle

    Repeater {
      anchors.fill: parent
      model: cornersModel

      Rectangle {
        id: pointMarker
        width: 9
        height: 9
        color: "black"
        

        Component.onCompleted: {
          x = (cx+1)/2*appRoot.width-width/2
          y =  (-cy+1)/2*appRoot.height-height/2
        }

        Text { text: id; x: 10; y: 10 }

        MouseArea {
          anchors.fill: parent
          drag.target: parent
          drag.threshold: 0
          drag.smoothed: false
          hoverEnabled: true
          onPressed: parent.color = "yellow" // visual feedback for the clicking
          onReleased: parent.color = "black"
          onEntered: if (pressedButtons == 0) { parent.color = "green" }
          onExited: if (pressedButtons == 0) { parent.color = "black"; }
        }

        onXChanged: {
          cx = (x+width/2)*2/appRoot.width-1;
          viewport.update();
        }
        onYChanged: {
          cy = -((y+height/2)*2/appRoot.height-1);
          viewport.update();
        }
      }
    }
  }
}
