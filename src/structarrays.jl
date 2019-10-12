push!!(xs::StructArrays.StructVector, ys...) = append!!(xs, ys)
append!!(xs::StructArrays.StructVector, ys) =
    StructArrays.grow_to_structarray!(xs, ys)
append!!(::StructArrays.StructVector{T}, ys) where {
    T <: Union{Tuple{}, NamedTuple{(), Tuple{}}}
} =
    StructArrays.StructVector(ys isa AbstractArray ? ys : collect(ys))

NoBang.push(xs::StructArrays.StructVector, ys...) = append(xs, ys)
NoBang.append(xs::StructArrays.StructVector, ys) = append!!(copy(xs), ys)
