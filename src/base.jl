"""
    push!!(collection, items...)

Push one or more `items` to collection.  Create a copy of `collection`
if it cannot be mutated or the element type does not match.

# Examples
```jldoctest
julia> using BangBang

julia> push!!((1, 2), 3)
(1, 2, 3)

julia> push!!([1, 2], 3)
3-element Array{Int64,1}:
 1
 2
 3

julia> push!!([1, 2], 3.0)
3-element Array{Float64,1}:
 1.0
 2.0
 3.0
```
"""
push!!(xs, i1, i2, items...) =
    foldl(push!!, items, init=push!!(push!!(xs, i1), i2))
push!!(xs, x) = may(push!, xs, x)

possible(::typeof(push!), x, ::Any) = ismutable(x)
possible(::typeof(push!), ::A, ::S) where {T, A <: AbstractVector{T}, S} =
    ismutable(A) && promote_type(T, S) <: T

"""
    append!!(dest, src)

Append items in `src` to `dest`.  Mutate `dest` if possible.  See also
[`push!!`](@ref).

# Examples
```jldoctest
julia> using BangBang

julia> append!!((1, 2), (3, 4))
(1, 2, 3, 4)

julia> append!!([1, 2], (3, 4))
4-element Array{Int64,1}:
 1
 2
 3
 4
```
"""
append!!(xs, ys) = may(append!, xs, ys)

possible(::typeof(append!), x, ::Any) = ismutable(x)
possible(::typeof(append!), ::A, ys) where {T, A <: AbstractVector{T}} =
    ismutable(A) && promote_type(T, eltype(ys)) <: T

"""
    setproperty!!(value, name, x)

# Examples
```jldoctest
julia> using BangBang

julia> setproperty!!((a=1, b=2), :b, 3)
(a = 1, b = 3)

julia> struct Immutable
           a
           b
       end

julia> setproperty!!(Immutable(1, 2), :b, 3)
Immutable(1, 3)

julia> mutable struct Mutable
           a
           b
       end

julia> s = Mutable(1, 2);

julia> setproperty!!(s, :b, 3)
Mutable(1, 3)

julia> s
Mutable(1, 3)
```
"""
setproperty!!(value, name, x) = may(_setproperty!, value, name, x)

possible(::typeof(_setproperty!), x, ::Any, ::Any) = ismutablestruct(x)
