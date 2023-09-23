import QtCore
import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import org.julialang

ApplicationWindow {
  title: "FileDialog"
  width: 640
  height: 480
  visible: true

  FileDialog {
      id: fileDialog
      title: "Please choose a file"
      fileMode: FileDialog.OpenFiles
      currentFolder: StandardPaths.standardLocations(StandardPaths.HomeLocation)[0]
      onAccepted: {
          Julia.singlefile(selectedFile)
          Julia.multifile(selectedFiles)
          Qt.quit()
      }
      onRejected: {
          console.log("Canceled")
          Qt.quit()
      }
      Component.onCompleted: visible = true
  }
}