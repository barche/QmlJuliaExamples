ENV["QSG_RENDER_LOOP"] = "basic"

using Test
using QML
using Images
using CxxWrap

imglock = ReentrantLock()
const img = zeros(RGB,512,512)

function circle!(img,r)
    width,height = size(img)
    ox = width/2
    oy = height/2
	
    for x in 1:width
        for y in 1:height
            if (x-ox)^2 + (y-oy)^2 < r^2
                img[x,y] = RGB(0.3, 0.3, 1)
            else
                img[x,y] = RGB(0,0,0)
            end
        end
    end
end

function startsimulation()
    Threads.@spawn begin
        startr = 20.0
        lastr = 250.0
        while true
            for r in range(startr, lastr, 1000)
                # lock(imglock)
                circle!(img,r)
                yield()
                # unlock(imglock)
            end
            for r in range(lastr, startr, 1000)
                # lock(imglock)
                circle!(img,r)
                yield()
                # unlock(imglock)
            end
        end
    end
end

function showlatest(buffer::Array{UInt32, 1}, width32::Int32, height32::Int32)
  buffer = reshape(buffer, size(img))
  buffer = reinterpret(ARGB32, buffer)
  # lock(imglock)
  buffer .= img
  # unlock(imglock)
  return
end

showlatest_cfunction = CxxWrap.@safe_cfunction(showlatest, Cvoid, 
                                               (Array{UInt32,1}, Int32, Int32))

qmlfile = joinpath(dirname(@__FILE__), "qml", "threadedcanvas.qml")
loadqml(qmlfile; showlatest = showlatest_cfunction)

# Run the application
startsimulation()
# Start the GUI
exec()
