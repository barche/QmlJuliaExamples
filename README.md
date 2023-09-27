# QmlJuliaExamples

These are examples for use with the [QML.jl](https://github.com/JuliaGraphics/QML.jl) package. To run them, clone this repository and `cd ` to one of its subdirectories. Then run `julia --project` and [instantiate the environment](https://pkgdocs.julialang.org/v1/environments/#Using-someone-else's-project).

Quickstart to test, from within Julia:

```julia
import LibGit2, Pkg
cd(mktempdir())
LibGit2.clone("https://github.com/barche/QmlJuliaExamples.git", "./")
cd("basic")
Pkg.activate(".")
Pkg.instantiate()
include("gui.jl")
```
