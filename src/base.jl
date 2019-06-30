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
possible(::typeof(push!), ::C, ::S) where {C <: MaybeMutableContainer, S} =
    ismutable(C) && promote_type(eltype(C), S) <: eltype(C)

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
possible(::typeof(append!), ::C, ys) where {C <: MaybeMutableContainer} =
    ismutable(C) && promote_type(eltype(C), eltype(ys)) <: eltype(C)

"""
    pushfirst!!(collection, items...)

# Examples
```jldoctest
julia> using BangBang

julia> pushfirst!!((1, 2), 3, 4)
(3, 4, 1, 2)

julia> pushfirst!!([1, 2], 3, 4)
4-element Array{Int64,1}:
 3
 4
 1
 2

julia> pushfirst!!([1, 2], 3, 4.0)
4-element Array{Float64,1}:
 3.0
 4.0
 1.0
 2.0
```
"""
pushfirst!!(xs, ys...) = may(pushfirst!, xs, ys...)

possible(::typeof(pushfirst!), ::Tuple, ::Vararg) = false
possible(::typeof(pushfirst!), ::C, ys...) where {C <: AbstractVector} =
    ismutable(C) && promote_type(eltype(C), map(typeof, ys)...) <: eltype(C)

"""
    pop!!(sequence) -> (sequence′, value)
    pop!!(assoc, key) -> (assoc′, value)
    pop!!(assoc, key, default) -> (assoc′, value)

# Examples
```jldoctest
julia> using BangBang

julia> pop!!([0, 1])
([0], 1)

julia> pop!!((0, 1))
((0,), 1)

julia> pop!!(Dict(:a => 1), :a)
(Dict{Symbol,Int64}(), 1)

julia> pop!!((a=1,), :a)
(NamedTuple(), 1)
```
"""
pop!!(xs, args...) = may(_pop!, xs, args...)
_pop!(xs, args...) = xs, pop!(xs, args...)

pure(::typeof(_pop!)) = NoBang.pop
possible(::typeof(_pop!), ::C, ::Vararg) where C = ismutable(C)

"""
    popfirst!!(sequence) -> (sequence′, value)

# Examples
```jldoctest
julia> using BangBang

julia> popfirst!!([0, 1])
([1], 0)

julia> popfirst!!((0, 1))
((1,), 0)
```
"""
popfirst!!(xs) = may(_popfirst!, xs)
_popfirst!(xs) = xs, popfirst!(xs)

pure(::typeof(_popfirst!)) = NoBang.popfirst
possible(::typeof(_popfirst!), ::C,) where C = ismutable(C)

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
