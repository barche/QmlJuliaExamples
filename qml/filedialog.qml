import QtQuick 2.2
import QtQuick.Dialogs 1.0
import QtQuick.Controls 1.0
import org.julialang 1.0

ApplicationWindow {
  title: "FileDialog"
  width: 640
  height: 480
  visible: true

  FileDialog {
      id: fileDialog
      title: "Please choose a file"
      selectMultiple: true
      folder: shortcuts.home
      onAccepted: {
          Julia.singlefile(fileDialog.fileUrl)
          Julia.multifile(fileDialog.fileUrls)
          Qt.quit()
      }
      onRejected: {
          console.log("Canceled")
          Qt.quit()
      }
      Component.onCompleted: visible = true
  }
}