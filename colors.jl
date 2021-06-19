using QML
using Qt5QuickControls_jll

loadqml(joinpath(dirname(Base.source_path()), "qml", "tutorial.qml"))
exec()

return

"""
Example for using a mouse area and for implementing animations in QML.
"""
