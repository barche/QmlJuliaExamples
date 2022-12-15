using QML

qmlfile = joinpath(@__DIR__, "qml", "text.qml")

fromfunction() = "From function call"
@qmlfunction fromfunction

# All keyword arguments to load are added as context properties on the QML side
loadqml(qmlfile, fromcontext="From context property")
exec()

"""
Example for setting text from Julia
"""
