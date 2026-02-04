using QML
using Qt6Graphs_jll

qml_file = joinpath(@__DIR__, "qml", "hellographs.qml")

qview = init_qquickview()
qmlurl = QUrlFromLocalFile(qml_file)
set_source(qview, qmlurl)
QML.show(qview)

exec()
