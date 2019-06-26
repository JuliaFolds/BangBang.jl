ImmutableContainer = Union{
    NamedTuple,
    Tuple,
}

push!!(xs, items...) = foldl(push!!, items, init=xs)

push!!(xs::AbstractVector{T}, x::S) where {T, S} =
    if promote_type(T, S) <: T
        push!(xs, x)
    else
        push(xs, x)
    end

push!!(xs::ImmutableContainer, items...) = push(xs, items...)

append!!(xs::AbstractVector{T}, ys) where T =
    if promote_type(T, eltype(ys)) <: T
        append!(xs, ys)
    else
        append(xs, ys)
    end

append!!(xs::ImmutableContainer, ys) = append(xs, ys)
