push!!(xs, items...) = foldl(push!!, items, init=xs)

push!!(xs::AbstractVector{T}, x::S) where {T, S} =
    if promote_type(T, S) <: T
        push!(xs, x)
    else
        push(xs, x)
    end

push!!(xs::Tuple, items...) = push(xs, items...)
push!!(xs::NamedTuple, items...) = push(xs, items...)
