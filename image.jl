using Test
using QML
using Images # for show of png
using TestImages

function test_display(d::JuliaDisplay)
  img = testimage("mandril_color")
  display(d, img)
end
@qmlfunction test_display

loadqml(joinpath(dirname(@__FILE__), "qml", "image.qml"))


# Run the application
exec()
