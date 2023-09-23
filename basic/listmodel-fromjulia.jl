ENV["QT_QUICK_CONTROLS_STYLE"] = "Fusion"

using QML

qml_data = QByteArray("""
import QtQuick
import QtQuick.Controls
import org.julialang

ApplicationWindow {
  title: "Test"
  visible: true
  Grid {
    rows: 5
    columns: 1
    Repeater {
      model: slider
      delegate: Row {
        Slider {
          id: sliderControl
          from: 0.0
          to: 2.0
          onValueChanged: {
            sliderval = value;
          }

          Component.onCompleted: {
            value = sliderval;
          }
          Connections {
		        target: slider
		        function onDataChanged() { sliderControl.value = sliderval; }
	        }
        }
      }
    }
  }
}
  """)

slidervalues = (collect(0.2:0.2:1.0))
slider = JuliaItemModel(slidervalues)
addrole!(slider, "sliderval", identity, setindex!)

qengine = init_qmlengine()
ctx = root_context(qengine)
set_context_property(ctx, "slider", slider)

qcomp = QQmlComponent(qengine)
set_data(qcomp, qml_data, QML.QUrl())
create(qcomp, qmlcontext());

exec_async()
