#test.jl
using QML

qml_file = joinpath(dirname(@__FILE__), "qml", "svg.qml")

loadqml(qml_file)

exec()
