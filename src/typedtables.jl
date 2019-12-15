Base.append!(dest::TypedTables.Table, src::SingletonVector{<:NamedTuple}) =
    push!(dest, @inbounds src[1])
