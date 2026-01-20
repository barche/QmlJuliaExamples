import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import jlqml
import QtQuick.Window

ApplicationWindow {
  id: appRoot
  title: "OpenGL"
  width: 500
  height: 500
  visible: true

  function markerSize() { return 9; }
  function screenPosition(storedPosition, l)
  {
    return (storedPosition + 1)/2 * l - markerSize()/2;
  }

  OpenGLViewport {
    id: viewport
    anchors.fill: parent
    renderFunction: render_triangle

    Repeater {
      anchors.fill: parent
      model: cornersModel

      Rectangle {
        id: pointMarker
        width: markerSize()
        height: markerSize()
        color: "black"
        

        Component.onCompleted: {
          x = screenPosition(cx, appRoot.width);
          y = screenPosition(-cy, appRoot.height);
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

        Connections {
          target: viewport
          function onWidthChanged(w) { pointMarker.x = screenPosition(cx, appRoot.width); }
          function onHeightChanged(h) { pointMarker.y = screenPosition(-cy, appRoot.height); }
        }
      }
    }
  }
}
