import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang

ApplicationWindow {
  title: "My Application"
  width: 800
  height: 600
  visible: true

  ColumnLayout {
    id: root
    spacing: 6
    anchors.fill: parent

    function do_plot()
    {
      if(jdisp === null)
        return;

      Julia.plotsin(jdisp, amplitude.value, frequency.value);
    }

    function init_and_plot()
    {
      if(jdisp === null || backendBox.currentIndex < 0)
        return;

      Julia.init_backend(jdisp.width, jdisp.height, backendBox.model[backendBox.currentIndex]);
      do_plot();
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignCenter

      Text {
        text: "Amplitude:"
      }

      Slider {
        id: amplitude
        width: 100
        value: 1.
        from: 0.1
        to: 5.
        onValueChanged: root.do_plot()
      }

      Text {
        text: "Frequency:"
      }

      Slider {
        id: frequency
        width: 100
        value: 1.
        from: 1.
        to: 50.
        onValueChanged: root.do_plot()
      }

      Text {
        text: "Backend"
      }

      ComboBox
      {
        id: backendBox
        model: ["None", "GR"]
        onCurrentIndexChanged: {
          root.init_and_plot()
        }
      }
    }

    JuliaDisplay {
      id: jdisp
      Layout.fillWidth: true
      Layout.fillHeight: true
      onHeightChanged: root.init_and_plot()
      onWidthChanged: root.init_and_plot()
    }
  }
}
