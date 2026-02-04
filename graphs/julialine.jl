using QML
using Qt6Graphs_jll

const qml_file = joinpath(dirname(@__FILE__), "qml", "julialine.qml")

function plot(xcoords,ycoords)
  loadqml(qml_file; xcoords, ycoords, xmin=minimum(xcoords), xmax=maximum(xcoords), ymin=minimum(ycoords), ymax=maximum(ycoords) )
  exec()
end

x = 0.0:π/20:2π
plot(x, sin.(x))

println("Include this Julia file from the REPL to use the plot(x,y) function to make a xy plot of arrays x and y")
