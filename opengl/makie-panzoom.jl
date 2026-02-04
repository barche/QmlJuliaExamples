using CxxWrap
using QML
using GLMakie
using QMLMakie
using Observables
using QMLMakie

set_theme!(theme_black())

# Observables for axis limits
const xlims = Observable([0.0, 1.0])
const ylims = Observable([-1.2, 1.2])

# Data
t = 0:0.01:10
y = sin.(t) .+ 0.1 * randn(length(t))

# Makie Figure and Axis, set initial limits by converting to tuples
fig = Figure(resolution = (700, 300));
ax = Axis(fig[1, 1], xlabel="Time", ylabel="Value", title="Pan/Zoom Demo",
          limits = (tuple(xlims[]...), tuple(ylims[]...)));
lines!(ax, t, y, color=:dodgerblue);
figscene = fig.scene;

# Called from QML to update the axes
function update_axes(xlims, ylims)
    xlims!(ax, xlims[1], xlims[2])
    ylims!(ax, ylims[1], ylims[2])
end

# Main plot
function render_callback(screen)
    display(screen, figscene)
end

QML.setGraphicsApi(QML.OpenGL)

params = JuliaPropertyMap("xlims" => xlims, "ylims" => ylims)
@qmlfunction update_axes

loadqml(joinpath(dirname(@__FILE__), "qml", "makie-panzoom.qml"),
        params = params,
        render_callback = @safe_cfunction(render_callback, Cvoid, (Any,))
        )
exec()
