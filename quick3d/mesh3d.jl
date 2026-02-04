using QmlJuliaExamples
using Observables
using QML
using unzip_jll
import Qt6Quick3D_jll
import Downloads
using ProgressMeter

function assetdir()
  path = joinpath(qmlassets(), "3dassets")
  if !isdir(path)
    mkdir(path)
  end
  return path
end

function download3dfile(uri, zipname)
  if !isfile(zipname)
    pmeter = ProgressUnknown()
    function progress(total, now)
      if total != 0 && pmeter isa ProgressUnknown
        pmeter = Progress(total)
      end
      if now != total
        update!(pmeter, now)
      else
        finish!(pmeter)
      end
    end
    println("Downloading $uri")
    Downloads.download(uri, zipname; progress)
  end
  run(`$(unzip()) -nq $zipname`)
end

function download_assets()
  asseturis = [
    "https://casual-effects.com/g3d/data10/common/model/teapot/teapot.zip",
    "https://casual-effects.com/g3d/data10/research/model/sportsCar/sportsCar.zip",
    "https://casual-effects.com/g3d/data10/common/model/mori_knob/mori_knob.zip",
    "https://casual-effects.com/g3d/data10/research/model/bunny/bunny.zip"
  ]
  cd(assetdir()) do
    for (i,uri) in enumerate(asseturis)
      download3dfile(uri, basename(uri))
    end
  end
end

download_assets()

@qmlfunction assetdir

qml_file = joinpath(dirname(@__FILE__), "qml", "mesh3d.qml")
loadqml(qml_file)
exec()

println("3D assets remain in directory $(assetdir())")
