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

julia> using DataFrames: DataFrame

julia> @assert push!!(DataFrame(a=[1], b=[2]), (a=3.5, b=4.5)) ==
           DataFrame(a=[1.0, 3.5], b=[2.0, 4.5])

julia> using StructArrays: StructVector

julia> @assert push!!(StructVector(a=[1], b=[2]), (a=3.5, b=4.5)) ==
           StructVector(a=[1.0, 3.5], b=[2.0, 4.5])

julia> using TypedTables: Table

julia> @assert push!!(Table(a=[1], b=[2]), (a=3.5, b=4.5)) ==
           Table(a=[1.0, 3.5], b=[2.0, 4.5])
```
"""
push!!(xs, i1, i2, items...) =
    foldl(push!!, items, init=push!!(push!!(xs, i1), i2))
push!!(xs, x) = may(push!, xs, x)

pure(::typeof(push!)) = NoBang.push
_asbb(::typeof(push!)) = push!!
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

julia> using DataFrames: DataFrame

julia> @assert append!!(DataFrame(a=[1], b=[2]), [(a=3.0, b=4.0)]) ==
           DataFrame(a=[1.0, 3.0], b=[2.0, 4.0])

julia> using StructArrays: StructVector

julia> @assert append!!(StructVector(a=[1], b=[2]), [(a=3.5, b=4.5)]) ==
           StructVector(a=[1.0, 3.5], b=[2.0, 4.5])

julia> using TypedTables: Table

julia> @assert append!!(Table(a=[1], b=[2]), [(a=3.5, b=4.5)]) ==
           Table(a=[1.0, 3.5], b=[2.0, 4.5])
```
"""
append!!(xs, ys) = may(append!, xs, ys)

pure(::typeof(append!)) = NoBang.append
_asbb(::typeof(append!)) = append!!
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

pure(::typeof(pushfirst!)) = NoBang.pushfirst
_asbb(::typeof(pushfirst!)) = pushfirst!!
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
    delete!!(assoc, key) -> assoc′
"""
delete!!(xs, key) = may(delete!, xs, key)

pure(::typeof(delete!)) = NoBang.delete
_asbb(::typeof(delete!)) = delete!!
possible(::typeof(delete!), ::C, ::Any) where C = ismutable(C)

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
    empty!!(collection) -> collection′

# Examples
```jldoctest
julia> using BangBang

julia> empty!!((1, 2, 3))
()

julia> empty!!((a=1, b=2, c=3))
NamedTuple()

julia> xs = [1, 2, 3];

julia> empty!!(xs)
0-element Array{Int64,1}

julia> xs
0-element Array{Int64,1}
```
"""
empty!!(xs) = may(empty!, xs)

pure(::typeof(empty!)) = NoBang._empty
_asbb(::typeof(empty!)) = empty!!
possible(::typeof(empty!), ::C) where C = ismutable(C)

#=
"""
    splice!!(sequence, i, [replacement]) -> (sequence′, item)
    splice!!(sequence, range, [replacement]) -> (sequence′, items)
"""
=#

"""
    splice!!(sequence, i, [replacement]) -> (sequence′, item)
"""
splice!!(xs, args...) = may(_splice!, xs, args...)
_splice!(xs, args...) = xs, splice!(xs, args...)

pure(::typeof(_splice!)) = NoBang.splice
possible(::typeof(_splice!), ::C, ::Any) where C = ismutable(C)
possible(::typeof(_splice!), xs::C, i::Integer, ::S) where {C, S} =
    possible(_splice!, xs, i) && promote_type(eltype(C), S) <: eltype(C)
possible(::typeof(_splice!), xs::C, i::Any, ::S) where {C, S} =
    possible(_splice!, xs, i) && promote_type(eltype(C), eltype(S)) <: eltype(C)

"""
    setindex!!(collection, value, indices...) -> collection′
"""
Base.@propagate_inbounds setindex!!(xs, v, I...) = may(_setindex!, xs, v, I...)

Base.@propagate_inbounds _setindex!(xs, v, I...) = (setindex!(xs, v, I...); xs)

pure(::typeof(_setindex!)) = NoBang._setindex
possible(::typeof(_setindex!), ::Union{Tuple, NamedTuple}, ::Vararg) = false
possible(::typeof(_setindex!), ::C, ::T, ::Vararg) where {C <: AbstractArray, T} =
    ismutable(C) && promote_type(eltype(C), T) <: eltype(C)
possible(::typeof(_setindex!), ::C, ::V, ::K) where {C <: AbstractDict, V, K} =
    ismutable(C) &&
    promote_type(keytype(C), K) <: keytype(C) &&
    promote_type(valtype(C), V) <: valtype(C)

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

function _setproperty!(value, name, x)
    setproperty!(value, name, x)
    return value
end

pure(::typeof(_setproperty!)) = NoBang.setproperty
possible(::typeof(_setproperty!), x, ::Any, ::Any) = ismutablestruct(x)


"""
    materialize!!(dest, x)
"""
@inline materialize!!(dest, x) = may(materialize!, dest, x)
# TODO: maybe instantiate `x` and be aware of `x`'s style

pure(::typeof(materialize!)) = NoBang.materialize
possible(::typeof(materialize!), x, ::Any) = ismutable(x)
