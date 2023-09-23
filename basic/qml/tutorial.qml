import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
    title: "My Application"
    width: 640
    height: 480
    visible: true

    Rectangle {
        id: page
        width: 320; height: 480
        color: "lightgray"

        Text {
            id: helloText
            text: "Hello world!"
            y: 30
            anchors.horizontalCenter: page.horizontalCenter
            font.pointSize: 24; font.bold: true

            MouseArea { id: mouseArea; anchors.fill: parent }

             states: State {
                 name: "down"; when: mouseArea.pressed == true
                 PropertyChanges { target: helloText; y: 160; rotation: 180; color: "red" }
             }

             transitions: Transition {
                 from: ""; to: "down"; reversible: true
                 ParallelAnimation {
                     NumberAnimation { properties: "y,rotation"; duration: 500; easing.type: Easing.InOutQuad }
                     ColorAnimation { duration: 500 }
                 }
             }
        }
    }

    Grid {
        id: colorPicker
        x: 4; anchors.bottom: page.bottom; anchors.bottomMargin: 4
        rows: 2; columns: 3; spacing: 3

        Cell { id: "c1"; cellColor: "red"; onClicked: helloText.color = c1.cellColor }
        Cell { id: "c2"; cellColor: "green"; onClicked: helloText.color = c2.cellColor }
        Cell { id: "c3"; cellColor: "blue"; onClicked: helloText.color = c3.cellColor }
        Cell { id: "c4"; cellColor: "yellow"; onClicked: helloText.color = c4.cellColor }
        Cell { id: "c5"; cellColor: "steelblue"; onClicked: helloText.color = c5.cellColor }
        Cell { id: "c6"; cellColor: "black"; onClicked: helloText.color = c6.cellColor }
    }
}
