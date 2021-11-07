# MUST disable threading in Qt
ENV["QSG_RENDER_LOOP"] = "basic"

using CxxWrap
using Observables
using QML
using GLMakie

const xpos = Node(collect(0.1:0.05:0.3))
const ypos = Node(rand(length(xpos[])))

plotscene = lines(xpos, ypos, color = :blue)
const needupdate = Observable(true)

on(plotscene.data_limits) do l
  needupdate[] = true
end

positionmodel = ListModel(tuple.(xpos[], ypos[]), false)

# Convert model coordinates to screen (inverse of to_world)
function to_screen(scene, point)
  cam = scene.camera
  cam_res = widths(pixelarea(scene)[])
  prj_view = cam.projection[] * cam.view[] * GLMakie.Makie.transformationmatrix(scene)[]
  pix_space = prj_view * Vec4f0(point[1], point[2], 0.0, 1.0)
  clip_space = (pix_space[1], pix_space[2])
  return ((clip_space .+ 1) ./ 2) .* cam_res
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

getscreenpos(xy::Tuple, i::Integer) = to_screen(plotscene, xy)[i]

function setpos(lm, x_or_y, listidx, i)
  newpos = [lm[listidx]...]
  newpos[i] = x_or_y
  lm[listidx] = (newpos...,)
  update_scene(lm)
end

setscreenpos(lm, x_or_y, listidx, i) = setpos(lm, to_world(plotscene, Point2f0(x_or_y, x_or_y))[i], listidx, i)

addrole(positionmodel, "xpos", xy -> xy[1], (lm, x_or_y, i) -> setpos(lm, x_or_y, i, 1))
addrole(positionmodel, "ypos", xy -> xy[2], (lm, x_or_y, i) -> setpos(lm, x_or_y, i, 2))
addrole(positionmodel, "xposscreen", xy -> getscreenpos(xy,1), (lm, x_or_y, i) -> setscreenpos(lm, x_or_y, i, 1))
addrole(positionmodel, "yposscreen", xy -> getscreenpos(xy,2), (lm, x_or_y, i) -> setscreenpos(lm, x_or_y, i, 2))

# Render function that takes a parameter t from a QML slider
function render_function(screen)
  display(screen, plotscene)
  if needupdate[] # The screen positions change if a resize happens and are unknown before the first render
    QML.force_model_update(positionmodel)
    needupdate[] = false
  end
  return
end

load(joinpath(dirname(@__FILE__), "qml", "makie-plot.qml"),
  positionModel = positionmodel,
  updates = JuliaPropertyMap("needupdate" => needupdate),
  render_callback = @safe_cfunction(render_function, Cvoid, (Any,))
)
exec()
