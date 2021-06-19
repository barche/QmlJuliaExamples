using QML
using Qt5QuickControls_jll

@qmlfunction println
loadqml(joinpath(dirname(@__FILE__), "qml", "drag.qml"))
exec()
