using Test
using QML
using Observables

# absolute path in case working dir is overridden
qml_file = joinpath(dirname(@__FILE__), "qml", "gui-view.qml")

hello() = "Hello from Julia"

counter = 0
const oldcounter = Observable(0)

function increment_counter()
  global counter, oldcounter
  oldcounter[] = counter
  counter += 1
end

function counter_value()
  global counter
  return counter
end

const bg_counter = Observable(0)

function counter_slot()
  global bg_counter
  bg_counter[] += 1
end

# This slows down the bg_counter display. It counts a *lot* faster this way, proving the main overhead is in the GUI update and not in the callback mechanism to Julia
const bg_counter_slow = Observable(0)
on(bg_counter) do newcount
  if newcount % 100 == 0
    bg_counter_slow[] = newcount
  end
end

@qmlfunction counter_slot hello increment_counter uppercase string

qview = init_qquickview()

engine = QML.engine(qview)
ctx = root_context(engine)
set_context_property(ctx, "guiproperties", JuliaPropertyMap("timer" => QTimer(), "oldcounter" => oldcounter, "bg_counter" => bg_counter_slow))

set_source(qview, QUrlFromLocalFile(qml_file))
watchqml(qview, qml_file)

QML.show(qview)
exec()

#println("Button was pressed $counter times")
#println("Background counter now at $(bg_counter[])")
