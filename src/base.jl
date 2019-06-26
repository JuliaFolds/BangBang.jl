push!!(xs, i1, i2, items...) =
    foldl(push!!, items, init=push!!(push!!(xs, i1), i2))
push!!(xs, x) = may(push!, xs, x)

possible(::typeof(push!), x, ::Any) = ismutable(x)
possible(::typeof(push!), ::A, ::S) where {T, A <: AbstractVector{T}, S} =
    ismutable(A) && promote_type(T, S) <: T

append!!(xs, ys) = may(append!, xs, ys)

possible(::typeof(append!), x, ::Any) = ismutable(x)
possible(::typeof(append!), ::A, ys) where {T, A <: AbstractVector{T}} =
    ismutable(A) && promote_type(T, eltype(ys)) <: T

setproperty!!(value, name, x) = may(_setproperty!, value, name, x)

possible(::typeof(_setproperty!), x, ::Any, ::Any) = ismutablestruct(x)
