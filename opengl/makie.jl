# MUST disable threading in Qt
ENV["QSG_RENDER_LOOP"] = "basic"

using CxxWrap
using Observables
using QML
using GLMakie
using QMLMakie
using FileIO

const catangle = Observable(0.0)
const cat = mesh(load(assetpath("cat.obj")), color = :blue)
const scene = cat.figure.scene
const lastrot = Ref(0.0)

# Render function that takes a parameter t from a QML slider
function render_function(screen)
  rotate_cam!(scene.children[1].children[1], (catangle[] - lastrot[]) * π/180, 0.0, 0.0)
  lastrot[] = catangle[]
  display(screen, scene)
end

QML.setGraphicsApi(QML.OpenGL)

loadqml(joinpath(dirname(@__FILE__), "qml", "makie.qml"),
  cat = JuliaPropertyMap("angle" => catangle),
  render_callback = @safe_cfunction(render_function, Cvoid, (Any,))
)
exec()
