using Observables
using QML
using Base.Threads

const palettes = ["magma", "inferno", "viridis", "turbo"]

centerX = Observable(-0.75)
centerY = Observable(0.0)
zoom = Observable(1.0)
palette = Observable("magma")

"""
    make_qimage_rgb888_mandelbrot(width::Integer, height::Integer;
                                  maxiter::Integer=1000,
                                  supersample::Integer=1,
                                  threaded::Bool=true,
                                  palette::Symbol=:magma)
  -> (buf::Vector{UInt8}, bytes_per_line::Int)

Generate a smoothly-colored Mandelbrot fractal as a **row-major** RGB888 buffer
suitable for `QImage(data, w, h, bytesPerLine, QImage::Format_RGB888)`.

- `maxiter`: iteration limit (higher = more detail, more work)
- `supersample`: N×N supersampling per pixel (1 = off, 2 or 3 looks nicer, slower)
- `threaded`: use `Threads.@threads` across scanlines
- `palette`: one of `:magma, :inferno, :viridis, :turbo` (simple built-in ramps)

Returns:
- `buf` : `Vector{UInt8}` with length `height * 3 * width` (RGB888, no padding)
- `bytes_per_line` = `3 * width`

Notes:
- The algorithm is compute-heavy by design; try `1920×1080`, `maxiter=2000`, `supersample=2`
  to see multi-threading speedups.
- Start Julia with multiple threads, e.g. `julia -t auto` or set `JULIA_NUM_THREADS`.
"""
function make_qimage_rgb888_mandelbrot(width::Integer, height::Integer, initialnextversion;
  maxiter::Integer=1000,
  supersample::Integer=1,
  threaded::Bool=false,
  palette::Symbol=Symbol(palette[]))

  w = Int(width)
  h = Int(height)
  (w > 0 && h > 0) || throw(ArgumentError("width and height must be positive"))
  ss = max(1, Int(supersample))

  # Allocate tightly-packed RGB888 buffer
  bytes_per_line = 3 * w
  buf = Vector{UInt8}(undef, h * bytes_per_line)

  # View parameters: maintain aspect ratio
  # Base horizontal span ~3.5 (typical Mandelbrot framing), then divide by zoom
  span_x = 3.5 / zoom[]
  span_y = span_x * (h / w)
  cx0, cy0 = float(centerX[]), float(centerY[])
  x_min = cx0 - span_x / 2
  y_min = cy0 - span_y / 2
  dx = span_x / w
  dy = span_y / h

  # Build a 256-color palette once
  pal = _palette_256(palette)

  # Work function for a single complex sample → smooth value in [0,1]
  @inline function mandel_smooth(xr::Float64, yr::Float64)::Float64
    # z_{n+1} = z_n^2 + c
    c_re, c_im = xr, yr
    z_re = 0.0
    z_im = 0.0
    k = 0
    @inbounds while k < maxiter
      # z^2: (a+bi)^2 = (a^2 - b^2) + 2ab i
      zr2 = z_re * z_re - z_im * z_im + c_re
      zi2 = 2.0 * z_re * z_im + c_im
      z_re = zr2
      z_im = zi2
      if (z_re * z_re + z_im * z_im) > 4.0   # escape radius^2
        # continuous / smooth iteration count
        # mu = k + 1 - log2(log(|z|))
        r = sqrt(z_re * z_re + z_im * z_im)
        mu = k + 1 - log2(log(r))
        return clamp(mu / maxiter, 0.0, 1.0)
      end
      k += 1
    end
    return 0.0  # inside set: map to first palette color (usually dark)
  end

  # Map a t in [0,1] to a color (r,g,b) using the 256-entry palette
  @inline function color_from_t(t::Float64)
    tt = clamp(t, 0.0, 1.0)
    idx = Int(floor(tt * 255.0))
    r = pal[3*idx+1]
    g = pal[3*idx+2]
    b = pal[3*idx+3]
    return r, g, b
  end

  # Main render loop (row-parallel)
  rowrange = 0:h-1
  if threaded
    @threads for y in rowrange
      if nextversion[] > initialnextversion
        break
      end
      _render_row!(buf, y, w, bytes_per_line, x_min, y_min, dx, dy, ss,
      mandel_smooth, color_from_t)
    end
  else
    for y in rowrange
      if nextversion[] > initialnextversion
        break
      end
      _render_row!(buf, y, w, bytes_per_line, x_min, y_min, dx, dy, ss,
      mandel_smooth, color_from_t)
    end
  end

  return buf, bytes_per_line
end

# --- helpers ---------------------------------------------------------------

# Render a single scanline at y into `buf` (disjoint writes → thread-safe).
@inline function _render_row!(buf::Vector{UInt8}, y::Int, w::Int, bpl::Int,
  x_min::Float64, y_min::Float64,
  dx::Float64, dy::Float64, ss::Int,
  mandel_smooth, color_from_t)
  row_off = y * bpl
  fy = y_min + (y + 0.5) * dy

  if ss == 1
    @inbounds @simd for x in 0:w-1
      fx = x_min + (x + 0.5) * dx
      t = mandel_smooth(fx, fy)
      r, g, b = color_from_t(t)
      i = row_off + 3x + 1
      buf[i] = r
      buf[i+1] = g
      buf[i+2] = b
    end
  else
    inv = 1.0 / (ss * ss)
    step_x = dx / ss
    step_y = dy / ss
    y0 = fy - 0.5 * dy + 0.5 * step_y
    @inbounds for x in 0:w-1
      x0 = x_min + x * dx + 0.5 * step_x
      acc = 0.0
      # N×N supersampling grid inside the pixel
      for sy in 0:ss-1
        yy = y0 + sy * step_y
        for sx in 0:ss-1
          xx = x0 + sx * step_x
          acc += mandel_smooth(xx, yy)
        end
      end
      t = acc * inv
      r, g, b = color_from_t(t)
      i = row_off + 3x + 1
      buf[i] = r
      buf[i+1] = g
      buf[i+2] = b
    end
  end
  return nothing
end

# Simple 256-color gradients (RGB888) in a flat Vector{UInt8}
function _palette_256(name::Symbol)
  stops = begin
    if name === :magma
      # black → deep purple → orange → pale yellow
      [(0.00, (0, 0, 3)),
        (0.15, (32, 5, 73)),
        (0.35, (106, 13, 125)),
        (0.55, (180, 49, 50)),
        (0.75, (251, 108, 20)),
        (1.00, (252, 253, 191))]
    elseif name === :inferno
      [(0.00, (0, 0, 4)),
        (0.15, (31, 12, 72)),
        (0.35, (103, 24, 117)),
        (0.55, (188, 55, 84)),
        (0.75, (252, 125, 30)),
        (1.00, (252, 255, 164))]
    elseif name === :viridis
      [(0.00, (68, 1, 84)),
        (0.25, (72, 40, 120)),
        (0.50, (62, 74, 137)),
        (0.75, (44, 113, 142)),
        (0.90, (32, 144, 140)),
        (1.00, (253, 231, 37))]
    elseif name === :turbo
      # Google's Turbo-like (approximate ramp via stops)
      [(0.00, (48, 18, 59)),
        (0.25, (41, 120, 142)),
        (0.50, (38, 201, 95)),
        (0.75, (201, 221, 34)),
        (0.90, (245, 144, 26)),
        (1.00, (133, 27, 13))]
    else
      error("Unknown palette: $name")
    end
  end
  pal = Vector{UInt8}(undef, 256 * 3)
  for i in 0:255
    t = i / 255
    r, g, b = _interp_color(stops, t)
    j = 3i + 1
    pal[j] = r
    pal[j+1] = g
    pal[j+2] = b
  end
  pal
end

@inline function _interp_color(stops::Vector{Tuple{Float64,NTuple{3,Int}}}, t::Float64)
  # find neighboring stops
  t = clamp(t, 0.0, 1.0)
  for k in 2:length(stops)
    t1, c1 = stops[k-1]
    t2, c2 = stops[k]
    if t <= t2
      # local interpolation parameter
      u = (t - t1) / max(t2 - t1, eps())
      # smoothstep for a softer gradient
      u = u * u * (3 - 2u)
      r = UInt8(round((1 - u) * c1[1] + u * c2[1]))
      g = UInt8(round((1 - u) * c1[2] + u * c2[2]))
      b = UInt8(round((1 - u) * c1[3] + u * c2[3]))
      return r, g, b
    end
  end
  # fallback (t == 1)
  c = stops[end][2]
  return UInt8(c[1]), UInt8(c[2]), UInt8(c[3])
end

"""
    progressive_mandelbrot(width::Int, height::Int;
                           lod_scales = [1//8, 1//4, 1//2, 1],   # fractional scales
                           iters      = [200, 600, 1200, 2400],  # optional per-pass iters
                           supersample::Int = 1,
                           threaded::Bool   = true)

Return a `Channel` that yields progressive RGB888 frames:
    (buf::Vector{UInt8}, bytes_per_line::Int, w::Int, h::Int, lod_index::Int, ver::Int)

- The early frames are small (fast), later ones reach full resolution.
- Use `iters` to also refine with higher iteration counts per pass.
"""
function progressive_mandelbrot(width, height, startversion, initialnextversion;
  lod_scales=[1 // 16, 1 // 8, 1 // 4, 1],
  iters=[100, 600, 1200, 2400],
  supersample::Int=1,
  threaded::Bool=true)

  n = max(length(lod_scales), length(iters))
  for k in 1:n
    s = k <= length(lod_scales) ? float(lod_scales[k]) : 1.0
    w_k = max(1, round(Int, width * s))
    h_k = max(1, round(Int, height * s))
    maxiter_k = k <= length(iters) ? iters[k] : iters[end]

    buf, stride = make_qimage_rgb888_mandelbrot(w_k, h_k, initialnextversion;
      maxiter=maxiter_k,
      supersample=supersample,
      threaded=threaded)

    if nextversion[] > initialnextversion
      # Abort if a new render sequence was started before this one is done
      break
    end

    newver = startversion+k-1
    put!(mandelchannel, (buf, stride, w_k, h_k, newver))
    update_version(newver)
  end
end

const mandelchannel = Channel{Tuple{Vector{UInt8},Int,Int,Int,Int}}(4)
nextversion = Threads.Atomic{Int}(0) # First version to produce when a new producer is started
version = Observable("0")
imagesize = Observable((0,0); ignore_equal_values=true)

const _version_lock = ReentrantLock()
function update_version(newver)
  @lock _version_lock version[] = string(newver)
end

function defaultimage()
  wh = 100
  image = QImage(QSize(wh,wh), QML.Format_RGB888)
  QML.fill(image, QColor("red"))
  return deepcopy(image), wh, wh
end

lastversion = -1
lastimage = defaultimage()[1]

function image_callback(id, requestedwidth, requestedheight)
  if requestedwidth <= 0 || requestedheight <= 0
    return defaultimage()
  end

  requestedversion = parse(Int, id[])

  imagesize[] = (requestedwidth,requestedheight)

  if requestedversion == lastversion
    return deepcopy(lastimage), QML.width(lastimage), QML.height(lastimage)
  end
  
  if !isready(mandelchannel)
    return deepcopy(lastimage), QML.width(lastimage), QML.height(lastimage)
  end
  buf, stride, w_k, h_k, takenversion = take!(mandelchannel)
  if takenversion > requestedversion
    return deepcopy(lastimage), QML.width(lastimage), QML.height(lastimage)
  end
  while takenversion < requestedversion
    buf, stride, w_k, h_k, takenversion = take!(mandelchannel)
  end
  global lastimage = QImage(pointer(buf), w_k, h_k, stride, QML.Format_RGB888)
  global lastversion = requestedversion
  return deepcopy(lastimage), w_k, h_k
end

function start_production(width, height)
  nb_levels = 4
  startversion = Threads.atomic_add!(nextversion, nb_levels)
  Threads.@spawn progressive_mandelbrot(width,height,startversion, startversion+nb_levels)
  return
end

on(imagesize) do s
  start_production(s...)
end

on(zoom) do s
  start_production(imagesize[]...)
end

on(centerX) do s
  start_production(imagesize[]...)
end

on(centerY) do s
  start_production(imagesize[]...)
end

on(palette) do p
  start_production(imagesize[]...)
end

imageprovider = ImageProvider(QML.Image, image_callback)
engine = init_qmlapplicationengine()
addImageProvider(engine, "mandelbrot", imageprovider)

qmlfile = joinpath(dirname(@__FILE__), "qml", "imageprovider.qml")
loadqml(engine, qmlfile; mandelbrot=JuliaPropertyMap(
  "version"=>version,
  "zoom"=>zoom,
  "centerX"=>centerX,
  "centerY"=>centerY,
  "palette"=>palette,
  "palettes"=>JuliaItemModel(palettes))
)
exec()


