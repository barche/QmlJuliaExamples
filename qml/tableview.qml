import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

// Dynamic columns idea from:
// http://stackoverflow.com/questions/27230818/qml-tableview-with-dynamic-number-of-columns

ApplicationWindow {
  title: "Arrays"
  width: 800
  height: 400
  visible: true

  ColumnLayout {
    id: root
    spacing: 6
    anchors.fill: parent

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Add column"
          onClicked: {
            var newyear = properties.years[properties.years.length-1]+1
            properties.years = properties.years.concat([newyear]);
          }
      }

      Button {
          Layout.alignment: Qt.AlignCenter
          text: "Remove column"
          onClicked: { properties.years = properties.years.slice(1) }
      }
    }

    Component
    {
      id: columnComponent
      TableViewColumn { width: 50 }
    }

    TableView {
      id: view
      Layout.fillWidth: true
      Layout.fillHeight: true
      model: nuclidesModel

      function update_columns() {
        var savedModel = model;
        model = null; // Avoid model updates during reset
        while(columnCount != 0) { // Remove existing columns first
          removeColumn(0);
        }
        addColumn(columnComponent.createObject(view, { "role": "name", "title": "Nuclide", "width": 100 }));
        for(var i=0; i<properties.years.length; i++)
        {
          var year = properties.years[i];
          var role = "y" + year
          addColumn(columnComponent.createObject(view, { "role": role, "title": year}));
        }
        model = savedModel;
      }

      // Update on role changes
      Connections {
        target: nuclidesModel
        function onRolesChanged() { view.update_columns(); }
      }

      // First-time init
      Component.onCompleted: update_columns()
    }
  }
}
