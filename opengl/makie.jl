using CxxWrap
using Observables
using QML
using QMLMakie
using GLMakie
using QMLMakie
using FileIO

catangle = Observable(0.0)
catmesh = load(assetpath("cat.obj"))
cat, axis = mesh(catmesh, color = :yellow)
wireframe!(axis, catmesh, color=(:black, 0.2), linewidth=1, transparency=true)
scatter!(axis, catmesh, color=(:black, 0.2))

lastrot = Ref(0.0)

on(catangle) do θ
  rotate_cam!(axis.scene, (θ - lastrot[]) * π/180, 0.0, 0.0)
  lastrot[] = θ
end

QML.setGraphicsApi(QML.OpenGL)

loadqml(joinpath(dirname(@__FILE__), "qml", "makie.qml"),
  cat = JuliaPropertyMap(
    "mesh" => cat,
    "angle" => catangle,
  )
)
exec_async()
