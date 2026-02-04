using QML
using Observables
using Dates

gettime() = Dates.format(now(), "HH:MM:SS")
const time = Observable(gettime())
qml_file = joinpath(dirname(@__FILE__), "qml", "basicclock.qml")

# Load the QML file, setting a context property named clock containing the time
engine = loadqml(qml_file, clock = JuliaPropertyMap("time" => time))

timer_task = @async begin
  while true
      time[] = gettime()
      sleep(1)
  end
end

# Run the application in the background
exec_async()
