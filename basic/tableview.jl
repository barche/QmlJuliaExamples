using Test
using QML
using Observables

# Implementation of a 2D array, to be used as model
struct NuclidesModel <: AbstractArray{Float64,2}
  nuclides::Vector{String}
  years::Vector{Cint}
  rows::Vector{Vector{Float64}}
end

NuclidesModel(nuclides, years) = NuclidesModel(nuclides, years, [[rand() for _ in years] for _ in nuclides])
extranuclides = ["Se74", "Se80", "126Xe", "144Sm", "153Eu"]

Base.size(t::NuclidesModel) = (length(t.nuclides), length(t.years))
Base.IndexStyle(::Type{<:NuclidesModel}) = IndexCartesian()
Base.getindex(t::NuclidesModel, i::Integer, j::Integer) = t.rows[i][j]
Base.setindex!(t::NuclidesModel, val, i::Integer, j::Integer) = t.rows[i][j] = val
function Base.push!(t::NuclidesModel, row)
  push!(t.rows, row)
  push!(t.nuclides, rand(extranuclides))
end
Base.deleteat!(t::NuclidesModel, rows) = deleteat!(t.rows, rows)
# This is used in the column insertion and removal procedure
function Base.similar(m::NuclidesModel, ::Type{S}, dims::Dims) where {S}
  if length(dims) == 1
    dims = (dims[1], 1)
  end
  function resized_copy(vec, newsize, default)
    result = deepcopy(vec)
    oldsize = length(vec)
    if newsize <= oldsize
      resize!(result, newsize)
      return result
    end
    append!(result, [default for _ in oldsize:newsize-1])
    return result
  end

  return NuclidesModel(resized_copy(m.nuclides, dims[1], "Unknown"), resized_copy(m.years, dims[2], 0))
end

# Initialize the model
nuclidesModel = JuliaItemModel(NuclidesModel(["Co60", "Cs137", "Ni63"], collect(Cint,2016:2025)))

# Make sure display is rounded to 2 digits
setgetter!(nuclidesModel, x -> string(round(x;digits=2)), QML.DisplayRole)

# function to get the header
function getheader(m::NuclidesModel, row_or_col, orientation, role)
  if orientation == QML.Horizontal
    return string(m.years[row_or_col])
  elseif orientation == QML.Vertical
    return m.nuclides[row_or_col]
  end
  return "Unknown"
end

# function to set the header
function setheader!(m::NuclidesModel, row_or_col, orientation, value, role)
  if orientation == QML.Horizontal
    m.years[row_or_col] = parse(Int,value)
  elseif orientation == QML.Vertical
    m.nuclides[row_or_col] = value
  end
end

# Register the above functions in the model
setheadergetter!(nuclidesModel, getheader)
setheadersetter!(nuclidesModel, setheader!)

# Update header when a column is added
on(values(nuclidesModel)) do model
  display(model)
  for (i,y) in enumerate(model.years)
    if y == 0 && i > 1
      model.years[i] = model.years[i-1] + 1
    end
  end
end

# Load QML after setting context properties, to avoid errors on initialization
qml_file = joinpath(dirname(@__FILE__), "qml", "tableview.qml")
loadqml(qml_file, nuclidesModel=nuclidesModel)

# Run the application
exec()
