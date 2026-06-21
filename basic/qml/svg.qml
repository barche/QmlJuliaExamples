//vectorimagetest.qml
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: mainWindow
    title: "SVG Viewer"
    visible: true
    width: 640
    height: 488

    Image {
        source: "assets/circle.svg"
    }
}
