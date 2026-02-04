using QML

qml_file = joinpath(dirname(@__FILE__), "qml", "multiplicationtable.qml")

struct MultiplicationTable <: AbstractArray{Int,2}
  size::Int
end

Base.size(t::MultiplicationTable) = (t.size, t.size)
Base.IndexStyle(::Type{<:MultiplicationTable}) = IndexCartesian()
Base.getindex(::MultiplicationTable, i::Integer, j::Integer) = i*j

# The square of the size here must be less than typemax(Int32) because of the QML TableView implementation in Qt, unfortunately
table = MultiplicationTable(45000)
tablemodel = JuliaItemModel(table)

loadqml(qml_file; tablemodel)

exec()
