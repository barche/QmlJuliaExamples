import QtQuick 2.0
import QtQuick.Controls 2.0
import org.julialang 1.0

ApplicationWindow {
  title: "Sketch"
  width: 640
  height: 480
  visible: true

  Canvas {
    id: myCanvas
    anchors.fill: parent

    onPaint: {
      var ctx = getContext("2d")
      ctx.strokeStyle = Qt.rgba(1, 0, 0, 1);
      ctx.lineWidth = 2;
      ctx.lineTo(position.x, position.y);
      ctx.stroke();
    }

    MouseArea{
      anchors.fill: parent
      onPressed: {
        myCanvas.getContext("2d").moveTo(mouseX,mouseY)
      }
      onPositionChanged: {
        position.x = mouseX
        position.y = mouseY
        myCanvas.requestPaint()
      }
    }
  }
}
