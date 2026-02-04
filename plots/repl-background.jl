using Plots
using QML

Plots.GR.inline()

qml_file = joinpath(dirname(@__FILE__), "qml", "repl-background.qml")



function setsize(w,h)
  gr(size=(Int64(round(w)),Int64(round(h))))
end

@qmlfunction pushdisplay setsize
loadqml(qml_file)
exec_async()

# In the new repl, run for example:
# using Plots
# plot(rand(10,2))
