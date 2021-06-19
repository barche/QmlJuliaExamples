import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.0

RowLayout {
    property alias text: nameText.text
    property alias from: slider.from
    property alias to: slider.to
    property alias value: slider.value
    property int fracDigits: 2
    property string units: ""
    //Layout.fillHeight: false
    Layout.fillWidth: true
    TextMetrics {
	id: defaultName
	text: "Default Name"
    }
    id: row
    Text {
	id: nameText
	Layout.preferredWidth: defaultName.width
	Layout.fillWidth: false
    }
    Slider {
	id: slider
	padding: 0
	Layout.fillWidth: true
	Layout.minimumWidth: 50
	Layout.maximumWidth: 100
	handle.implicitHeight: defaultName.height
	handle.implicitWidth: defaultName.height

    }
    Text {
	Layout.fillWidth: false
	Layout.preferredWidth: 30
	id: valueText
	text: slider.value.toFixed(fracDigits) + " " + units
    }
}

