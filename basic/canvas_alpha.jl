using QML
using Observables
using ColorTypes
import CxxWrap # for safe_cfunction

const qmlfile = joinpath(dirname(Base.source_path()), "qml", "canvas_alpha.qml")

diameter = Observable(0.0)
alpha = Observable(0.0)

convertbuffer(buffer::Ptr{UInt32}, w, h) = reinterpret(ARGB32, unsafe_wrap(Array, buffer, (w, h)))

# callback to paint circle
function paint_circle(buffer::Ptr{UInt32}, width32::Int32, height32::Int32)
    width::Int = width32
    height::Int = height32
    buffer = convertbuffer(buffer, width, height)

    center_x = width/2
    center_y = height/2
    rad2 = (diameter[]/2)^2
    for x in 1:width
        for y in 1:height
            if (x-center_x)^2 + (y-center_y)^2 < rad2
                buffer[x,y] = ARGB32(1, 0, 0, 1) #red
            else
                buffer[x,y] = ARGB32(0, 0, 0, 1) #black
            end
        end
    end
    return
end

# callback to paint square
function paint_square(buffer::Ptr{UInt32}, width32::Int32, height32::Int32)
    width::Int = width32
    height::Int = height32
    buffer = convertbuffer(buffer, width, height)

    center_x = width/2
    center_y = height/2
    halfside = diameter[]/2
    for x in 1:width
        for y in 1:height
            if abs(x-center_x) < halfside && abs(y-center_y) < halfside
                buffer[x,y] = ARGB32(0, 0, 1, alpha[]) #blue
            else
                buffer[x,y] = ARGB32(0, 0, 0, alpha[]) #black
            end
        end
    end
    return
end

loadqml(qmlfile,
     parameters=JuliaPropertyMap("diameter" => diameter, "alpha" => alpha),
     circle_cfunction = CxxWrap.@safe_cfunction(paint_circle, Cvoid, (Ptr{UInt32}, Int32, Int32)),
     square_cfunction = CxxWrap.@safe_cfunction(paint_square, Cvoid, (Ptr{UInt32}, Int32, Int32)))

exec()
