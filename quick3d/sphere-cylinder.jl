using QML
import Qt6Quick3D_jll

# absolute path in case working dir is overridden
qml_file = joinpath(dirname(@__FILE__), "qml", "sphere-cylinder.qml")
loadqml(qml_file)
exec()
