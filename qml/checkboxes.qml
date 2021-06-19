import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.julialang 1.0

ApplicationWindow {
    title: "My Application"
    width: 620
    height: 420
    visible: true

    Item {
        id: res
        property double result: 0.0
    }

    ColumnLayout{
        id: page
        height: parent.height
        width: 500
        x:30
        Text {
            id: helloText
            text: "KPS Optimizer"
            Layout.alignment: Qt.AlignCenter
            font.pointSize: 24; font.bold: true
        }
        GroupBox {
            title: "Plot diagrams, showing the scaling effects of KPS scenarios:      "
            Layout.alignment: Qt.AlignTop
            ColumnLayout {
                y: 20
                CheckBox { id:chk1; text: "plot_costs_per_watt"; checked: true }
                CheckBox { id:chk2; text: "plot_area"; checked: true }
                CheckBox { id:chk3; text: "plot_effective_LoD" }
                CheckBox { id:chk4; text: "plot_power_per_area" }
                CheckBox { id:chk5; text: "plot_force_per_area" }
                CheckBox { id:chk6; text: "plot_power_per_force" }
                CheckBox { id:chk7; text: "plot_height" }
                CheckBox { id:chk8; text: "plot_drum_diameter" }
                CheckBox { id:chk9; text: "plot_drum_width" }
            }
        }

    }
    Button {
        id: btnPlot
        x:510
        y:110
        text: "Plot"
        onClicked: {
            res.result = chk1.checked + 2*chk2.checked+4*chk3.checked + 8*chk4.checked
            res.result += 16*chk5.checked + 32*chk6.checked + 64*chk7.checked + 128*chk8.checked +256*chk9.checked
            Julia.plot_diagram(res.result)
        }
    }
}
