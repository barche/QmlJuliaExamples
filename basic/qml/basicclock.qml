// basicclock.qml

import QtQuick
import QtQuick.Controls

ApplicationWindow {
    visible: true
    width: 300
    height: 150
    title: "Digital Clock"

    Rectangle {
        anchors.fill: parent
        color: "#2E3440"

        Text {
            id: timeText
            anchors.centerIn: parent
            text: clock.time
            font.pixelSize: 48
            color: "#D8DEE9"
        }
    }
}