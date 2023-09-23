import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
  title: "Arrays"
  width: 800
  height: 400
  visible: true

  ColumnLayout {
    id: root
    spacing: 6
    anchors.centerIn: parent

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Add column"
          onClicked: {
            nuclidesModel.appendColumn(Array.from({length: nuclidesModel.rowCount()}, () => Math.random()));
          }
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Remove column"
          onClicked: { nuclidesModel.removeColumn(0); }
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Add row"
          onClicked: {
            nuclidesModel.appendRow(Array.from({length: nuclidesModel.columnCount()}, () => Math.random()));
          }
      }
    }

    Item {

      Layout.alignment: Qt.AlignCenter
      Layout.preferredWidth: 700
      Layout.preferredHeight: 350

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

        model: nuclidesModel

        delegate: Rectangle {
          implicitWidth: 40
          implicitHeight: 15
          Text {
            anchors.centerIn: parent
            text: display
          }
        }
      }
    }
  }
}
