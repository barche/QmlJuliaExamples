using QML

# Julia Fruit model item. Each field is automatically a role, by default
mutable struct Fruit
  name::String
  cost::Float64
  attributes::JuliaItemModel
end

# Attributes must have a description and are nested model items
mutable struct Attribute
  description::String
end

# Construct using attributes from an array of QVariantMap, as in the append call in QML
function Fruit(name, cost, attributes::AbstractArray)
  return Fruit(name, cost, JuliaItemModel([Attribute(QML.value(a)["description"]) for a in attributes]))
end

# setter for the attributes
function setattributes!(fruitlist, attributes, row, col)
  fruitlist[row].attributes = JuliaItemModel([Attribute(QML.value(a)["description"]) for a in attributes])
  return
end

# Use a view, since no ApplicationWindow is provided in the QML
qview = init_qquickview()

# Our initial data
fruitlist = [
  Fruit("Apple", 2.45, JuliaItemModel([Attribute("Core"), Attribute("Deciduous")])),
  Fruit("Banana", 1.95, JuliaItemModel([Attribute("Tropical"), Attribute("Seedless")])),
  Fruit("Cumquat", 3.25, JuliaItemModel([Attribute("Citrus")])),
  Fruit("Durian", 9.95, JuliaItemModel([Attribute("Tropical"), Attribute("Smelly")]))]

# Set a context property with our JuliaItemModel
fruitmodel = JuliaItemModel(fruitlist)
setsetter!(fruitmodel, setattributes!, roleindex(fruitmodel, "attributes"))
set_context_property(qmlcontext(), "fruitModel", fruitmodel)

# Add indices for the roles we need to set explicitly using setData in QML
roles = JuliaPropertyMap()
roles["cost"] = roleindex(fruitmodel, "cost")
set_context_property(qmlcontext(), "roles", roles)


# Load QML after setting context properties, to avoid errors on initialization
qml_file = joinpath(dirname(@__FILE__), "qml", "dynamiclist.qml")
set_source(qview, QUrlFromLocalFile(qml_file))
QML.show(qview)

# Run the application
exec()

# Show that the Julia fruitlist was modified
# Note that not all modifications happen in-place, to get the new fruitlist use the values function:
fruitlist = values(fruitmodel)[]
println("Your fruits:")
for f in fruitlist
  println("  $(f.name), \$$(f.cost)")
end
