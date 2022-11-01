ENV["QT_QUICK_CONTROLS_STYLE"] = "Fusion"

using QML
using Qt5QuickControls2_jll

qml_data = QByteArray("""
import QtQuick 2.12
import QtQuick.Controls 2.4
import org.julialang 1.1

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
slider = ListModel(slidervalues)
addrole!(slider, "sliderval", identity, setindex!)

qengine = init_qmlengine()
ctx = root_context(qengine)
set_context_property(ctx, "slider", slider)

qcomp = QQmlComponent(qengine)
set_data(qcomp, qml_data, QML.QUrl())
create(qcomp, qmlcontext());

exec_async()
