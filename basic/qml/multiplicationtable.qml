import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import jlqml

ApplicationWindow {
  title: "Arrays"
  width: 800
  height: 400
  visible: true

  Item {
    anchors.centerIn: parent
    anchors.fill: parent

    HorizontalHeaderView {
      id: horizontalHeader
      syncView: tableView
      anchors.left: tableView.left
      clip: true
    }

    VerticalHeaderView {
      id: verticalHeader
      syncView: tableView
      anchors.top: tableView.top
      clip: true
    }

    TableView {
      id: tableView

      anchors.fill: parent
      anchors.topMargin: horizontalHeader.height
      anchors.leftMargin: verticalHeader.width

      columnSpacing: 1
      rowSpacing: 1
      clip: true

      model: tablemodel
      selectionModel: ItemSelectionModel {}

      delegate: Rectangle {
        implicitWidth: Math.max(text.implicitWidth+5, 40)
        implicitHeight: Math.max(text.implicitHeight+2, 15)
        required property bool selected
        required property bool current
        border.width: current ? 2 : 0
        color: selected ? "lightblue" : palette.base
        Text {
          id: text
          anchors.centerIn: parent
          text: display
        }
      }

      ScrollBar.vertical: ScrollBar {
        id: vbar
        visible: tableView.moving
        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          onEntered: vbar.visible = true
          onExited: vbar.visible = false
        }
      }
      ScrollBar.horizontal: ScrollBar {
        id: hbar
        visible: tableView.moving
        MouseArea {
          anchors.fill: parent
          onEntered: hbar.visible = true
          onExited: hbar.visible = false
        }
      }
    }

    // MouseArea {
    //   width: parent.width
    //   height: 30
    //   anchors.bottom: parent.bottom
    //   hoverEnabled: true
    //   onEntered: hbar.visible = true
    //   onExited: hbar.visible = false
    //   propagateComposedEvents: true
    // }
  }
}
