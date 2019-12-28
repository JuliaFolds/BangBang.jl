Base.append!(dest::TypedTables.Table, src::SingletonVector{<:NamedTuple}) =
    push!(dest, first(src))
