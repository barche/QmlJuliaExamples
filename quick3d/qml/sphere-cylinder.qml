import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick3D
import jlqml

ApplicationWindow {
  title: "My Application"
  width: 1280
  height: 720
  visible: true

  View3D {
    id: view
    anchors.fill: parent

    //! [environment]
    environment: SceneEnvironment {
      clearColor: "skyblue"
      backgroundMode: SceneEnvironment.Color
    }
    //! [environment]

    //! [camera]
    PerspectiveCamera {
      position: Qt.vector3d(0, 200, 300)
      eulerRotation.x: -30
    }
    //! [camera]

    //! [light]
    DirectionalLight {
      eulerRotation.x: -30
      eulerRotation.y: -70
    }
    //! [light]

    //! [objects]
    Model {
      position: Qt.vector3d(0, -200, 0)
      source: "#Cylinder"
      scale: Qt.vector3d(2, 0.2, 1)
      materials: [ PrincipledMaterial {
          baseColor: "red"
        }
      ]
    }

    Model {
      position: Qt.vector3d(0, 150, 0)
      source: "#Sphere"

      materials: [ PrincipledMaterial {
          baseColor: "blue"
        }
      ]

      //! [animation]
      SequentialAnimation on y {
        loops: Animation.Infinite
        NumberAnimation {
          duration: 3000
          to: -150
          from: 150
          easing.type:Easing.InQuad
        }
        NumberAnimation {
          duration: 3000
          to: 150
          from: -150
          easing.type:Easing.OutQuad
        }
      }
      //! [animation]
    }
    //! [objects]
  }
}
