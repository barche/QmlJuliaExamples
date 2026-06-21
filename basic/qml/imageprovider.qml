import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
  visible: true
  width: 900
  height: 700
  title: "Mandelbrot Viewer"

  ColumnLayout {
    anchors.fill: parent

    // -------------------- TOOLBAR --------------------
    ToolBar {
      Layout.fillWidth: true

      RowLayout {
        spacing: 12

        Label {
          text: "Zoom:"
        }

        TextField {
          text: mandelbrot.zoom
          onEditingFinished: mandelbrot.zoom = parseFloat(text)

          validator: DoubleValidator {
            locale: "C"
          }

        }

        Label {
          text: "Center X:"
        }

        TextField {
          text: mandelbrot.centerX
          onEditingFinished: {
            mandelbrot.centerX = parseFloat(text);
          }

          validator: DoubleValidator {
            locale: "C"
          }

        }

        Label {
          text: "Center Y:"
        }

        TextField {
          text: mandelbrot.centerY
          onEditingFinished: mandelbrot.centerY = parseFloat(text)

          validator: DoubleValidator {
            locale: "C"
          }

        }

        Label {
          text: "Palette:"
        }

        ComboBox {
          Layout.alignment: Qt.AlignCenter
          textRole: "display"
          valueRole: "display"
          model: mandelbrot.palettes
          currentValue: "magma"
          onActivated: mandelbrot.palette = currentValue
        }

        Button {
          text: "Reset"
          onClicked: {
            mandelbrot.zoom = 1;
            mandelbrot.centerX = -0.5;
            mandelbrot.centerY = 0;
          }
        }

      }

    }

    // -------------------- IMAGE AREA --------------------
    Item {
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true

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

      PinchHandler {
        id: pinch
        target: null

        onScaleChanged: (delta) => {
          mandelbrot.zoom *= delta;
        }
      }

      WheelHandler {
        id: touchPadDrag
        target: null
        acceptedDevices: PointerDevice.TouchPad | PointerDevice.Mouse

        onWheel: (event) => {
          if(event.phase != Qt.NoScrollPhase) // True for touchpads, so two-finger pan instead of zoom
          {
            mandelbrot.centerX -= event.pixelDelta.x / (width * mandelbrot.zoom) * Screen.devicePixelRatio;
            mandelbrot.centerY -= event.pixelDelta.y / (height * mandelbrot.zoom) * Screen.devicePixelRatio;
          } else { // Real mouse wheel, so zoom
            const factor = event.angleDelta.y > 0 ? 1.25 : 0.8;
            mandelbrot.zoom *= factor;
          }
          event.accepted = true
        }
      }

      DragHandler {
        target: null

        onActiveTranslationChanged: (delta) => {
          mandelbrot.centerX -= delta.x / (width * mandelbrot.zoom) * Screen.devicePixelRatio;
          mandelbrot.centerY -= delta.y / (height * mandelbrot.zoom) * Screen.devicePixelRatio;
        }
      }
    }
  }
}
