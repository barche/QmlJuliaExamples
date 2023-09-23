import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang
import "content"  // for NamedSlider

ApplicationWindow {
	visible: true
	width: 640
	height: 480
	title: qsTr("Julia Canvas")

	ColumnLayout {
		anchors.fill: parent

		NamedSlider {
			text: "diameter"; from: 50; to: 640; value: 200
			onValueChanged: parameters.diameter = value
		}

		JuliaCanvas {
			id: circle_canvas
			paintFunction: paint_cfunction
			Layout.fillWidth: true
			Layout.fillHeight: true
			Layout.minimumWidth: 100
			Layout.minimumHeight: 100
		}
	}

	Connections {
		target: parameters
		function onDiameterChanged() { circle_canvas.update(); }
	}
}

