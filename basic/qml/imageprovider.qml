import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
  visible: true
  width: 640
  height: 480

  Image {
    id: image
    anchors.fill: parent
    sourceSize.width: width
    sourceSize.height: height
    asynchronous: true
    retainWhileLoading: true
    source: "image://mandelbrot/" + mandelbrot.version
    cache: false
  }
}