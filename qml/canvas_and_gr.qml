import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.0
import org.julialang 1.1
import "content"  // for NamedSlider

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Canvas and GR Example")

    ColumnLayout {
	id: root
	anchors.fill: parent
	RowLayout {
	    ColumnLayout {
		CheckBox {
		    checked: true
		    text: "invert sin plot"
		    onCheckedChanged: parameters.invert_sin = checked
		    Component.onCompleted: parameters.invert_sin = checked
		}
		NamedSlider {
		    text: "frequency"; from: 1; to: 10; value: 5
		    onValueChanged: parameters.frequency = value
		}
		NamedSlider {
		    text: "amplitude"; from: 1; to: 5; value: 2.3
		    onValueChanged: parameters.amplitude = value
		}
		NamedSlider {
		    text: "diameter"; from: 50; to: 100; value: 80
		    onValueChanged: parameters.diameter = value
		}
	    }
	    JuliaPaintedItem {
		id: sin_plot
		Layout.minimumHeight: 100
		Layout.minimumWidth: 200
		Layout.fillWidth: true
		Layout.fillHeight: true
		paintFunction: paint_sin_plot_wrapped
	    }
	    JuliaPaintedItem {
		id: cos_plot
		Layout.minimumHeight: 100
		Layout.minimumWidth: 200
		Layout.fillWidth: true
		Layout.fillHeight: true
		paintFunction: paint_cos_plot_wrapped
	    }
	}
	RowLayout {
		TextArea {
		    Layout.fillHeight: true
		    Layout.minimumWidth: 200
		    textFormat: TextEdit.RichText
		    text: parameters.description_text
		    readOnly: true
		}
	    JuliaCanvas {
		id: circle_canvas
		Layout.fillWidth: true
		Layout.fillHeight: true
		Layout.minimumWidth: 100
		Layout.minimumHeight: 100
		paintFunction: paint_canvas_wrapped
	    }
	}	    
    }
    JuliaSignals {
	signal updateCanvas()
	signal updateSinPlot()
	signal updateCosPlot()
	onUpdateCanvas: circle_canvas.update()
	onUpdateSinPlot: sin_plot.update()
	onUpdateCosPlot: cos_plot.update()
    }
}

