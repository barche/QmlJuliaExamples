import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import org.julialang 1.0

ApplicationWindow {
    visible: true
    width: 200
    height: 200
    title: "FizzBuzz"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        TextField {
            Layout.fillWidth: true
            placeholderText: "Input a number..."
            text: ""
            id: textField
            onTextChanged: Julia.do_fizzbuzz(textField.text, fizzbuzz)
        }
        Text {
            id: text
            text: fizzbuzz.message
        }
        Button {
            text: 'Quit'
            onClicked: Qt.quit()
        }
        Text {
            id: lastFizzBuzz
            text: "No fizzbuzz yet!"
        }
    }

    JuliaSignals {
      signal fizzBuzzFound(var fizzbuzzvalue)
      signal fizzBuzzFail()
      onFizzBuzzFound: lastFizzBuzz.text = fizzbuzzvalue
      onFizzBuzzFail: textField.placeholderText = "3*5 = ..."
    }
}
