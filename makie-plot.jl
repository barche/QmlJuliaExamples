# MUST disable threading in Qt
ENV["QSG_RENDER_LOOP"] = "basic"

using CxxWrap
using Observables
using QML
using GLMakie
using Makie
using GeometryBasics

const xpos = Observable(collect(0.1:0.05:0.3))
const ypos = Observable(rand(length(xpos[])))

fig, ax, pl = lines(xpos, ypos, color = :blue)
autolimits!(ax)

figscene = fig.scene
axscene = ax.scene

const needupdate = Observable(true)

on(ax.finallimits) do l
  needupdate[] = true
end

positionmodel = JuliaItemModel(tuple.(xpos[], ypos[]), false)

# Convert model coordinates to screen (inverse of to_world)
function to_screen(scene, point)
  cam = scene.camera
  plotrect = pixelarea(scene)[]
  cam_res = widths(plotrect)
  prj_view = cam.projection[] * cam.view[] * Makie.transformationmatrix(scene)[]
  pix_space = prj_view * Vec4f0(point[1], point[2], 0.0, 1.0)
  clip_space = (pix_space[1], pix_space[2])
  return ((clip_space .+ 1) ./ 2) .* cam_res .+ Makie.origin(plotrect)
end

function update_scene(lm)
  l = length(lm)
  newx = zeros(l)
  newy = zeros(l)
  for i in 1:l
    (newx[i], newy[i]) = lm[i]
  end
  xpos[] = newx
  ypos[] = newy
  return
end

getscreenpos(xy::Tuple, i::Integer) = to_screen(axscene, xy)[i]

function setpos(lm, x_or_y, listidx, i)
  newpos = [lm[listidx]...]
  newpos[i] = x_or_y
  lm[listidx] = (newpos...,)
  update_scene(lm)
end

function setscreenpos(lm, x_or_y, listidx, i)
  axscreenpos = Point2f0(x_or_y, x_or_y) .- Makie.origin(pixelarea(axscene)[])
  setpos(lm, to_world(axscene, axscreenpos)[i], listidx, i)
end

addrole!(positionmodel, "xpos", xy -> xy[1], (lm, x_or_y, i) -> setpos(lm, x_or_y, i, 1))
addrole!(positionmodel, "ypos", xy -> xy[2], (lm, x_or_y, i) -> setpos(lm, x_or_y, i, 2))
addrole!(positionmodel, "xposscreen", xy -> getscreenpos(xy,1), (lm, x_or_y, i) -> setscreenpos(lm, x_or_y, i, 1))
addrole!(positionmodel, "yposscreen", xy -> getscreenpos(xy,2), (lm, x_or_y, i) -> setscreenpos(lm, x_or_y, i, 2))

# Render function that takes a parameter t from a QML slider
function render_function(screen)
  display(screen, figscene)
  if needupdate[] # The screen positions change if a resize happens and are unknown before the first render
    QML.force_model_update(positionmodel)
    needupdate[] = false
  end
  return
end

QML.setGraphicsApi(QML.OpenGL)

loadqml(joinpath(dirname(@__FILE__), "qml", "makie-plot.qml"),
  positionModel = positionmodel,
  updates = JuliaPropertyMap("needupdate" => needupdate),
  render_callback = @safe_cfunction(render_function, Cvoid, (Any,))
)
exec()
