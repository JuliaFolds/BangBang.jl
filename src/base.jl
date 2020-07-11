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

julia> using StaticArrays: SVector

julia> @assert push!!(SVector(1, 2), 3.0) === SVector(1.0, 2.0, 3.0)

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
push!!
push!!(xs, i1, i2, items...) =
    foldl(push!!, items, init=push!!(push!!(xs, i1), i2))
push!!(xs, x) = may(push!, xs, x)

pure(::typeof(push!)) = NoBang.push
_asbb(::typeof(push!)) = push!!
possible(::typeof(push!), x, ::Any) = implements(push!, x)
possible(::typeof(push!), ::C, ::S) where {C <: MaybeMutableContainer, S} =
    implements(push!, C) && promote_type(eltype(C), S) <: eltype(C)

"""
    append!!(dest, src) -> dest′

Append items in `src` to `dest`.  Mutate `dest` if possible.

This function "owns" `dest` but not `src`; i.e., returned value
`dest′` does not alias `src`.  For example, `append!!(Empty(Vector),
src)` shallow-copies `src` instead of returning `src` as-is.

See also [`push!!`](@ref).

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

julia> using StaticArrays: SVector

julia> @assert append!!(SVector(1, 2), (3, 4)) === SVector(1, 2, 3, 4)

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

`append!!` does not own the second argument:

```jldoctest; setup = :(using BangBang)
julia> xs = [1, 2, 3];

julia> ys = append!!(Empty(Vector), xs)
3-element Array{Int64,1}:
 1
 2
 3

julia> ys === xs
false
```
"""
append!!
@inline append!!(xs, ys) = __append!!__(xs, ys)

"""
    __append!!__(dest::CustomType, src) -> dest′

This is an overload interface for `append!!`.  This function must
dispatch on the first argument and implemented by the owner of the
type of the first argument.
"""
__append!!__
@inline __append!!__(xs, ys) = __appendto!!__(xs, ys)

"""
    __appendto!!__(dest, src::CustomType) -> dest′

This is an overload interface for `append!!`.  This function must
dispatch on the second argument and implemented by the owner of the
type of second first argument.  This function is used when there is
no specific implementation for [`__append!!__`](@ref) is found.
"""
__appendto!!__
@inline __appendto!!__(xs, ys) = may(_append!, xs, ys)

# An indirection for supporting dispatch on the second argument.
_append!(dest, src) = append!(dest, src)
_append!(dest, src::SingletonVector) = push!(dest, src.value)

pure(::typeof(_append!)) = NoBang.append
_asbb(::typeof(append!)) = append!!
possible(::typeof(_append!), x, ::Any) = implements(push!, x)
possible(::typeof(_append!), ::C, ys) where {C <: MaybeMutableContainer} =
    implements(push!, C) && promote_type(eltype(C), eltype(ys)) <: eltype(C)

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

julia> using StaticArrays: SVector

julia> @assert pushfirst!!(SVector(1, 2), 3, 4) === SVector(3, 4, 1, 2)
```
"""
pushfirst!!
pushfirst!!(xs, ys...) = may(pushfirst!, xs, ys...)

pure(::typeof(pushfirst!)) = NoBang.pushfirst
_asbb(::typeof(pushfirst!)) = pushfirst!!
possible(::typeof(pushfirst!), ::Tuple, ::Vararg) = false
possible(::typeof(pushfirst!), ::C, ys...) where {C <: AbstractVector} =
    implements(push!, C) && promote_type(eltype(C), map(typeof, ys)...) <: eltype(C)

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

julia> using StaticArrays: SVector

julia> @assert pop!!(SVector(1, 2)) === (SVector(1), 2)
```
"""
pop!!
pop!!(xs, args...) = may(_pop!, xs, args...)
_pop!(xs, args...) = xs, pop!(xs, args...)

pure(::typeof(_pop!)) = NoBang.pop
possible(::typeof(_pop!), ::C, ::Vararg) where C = implements(push!, C)

"""
    deleteat!!(assoc, i) -> assoc′

# Examples
```jldoctest
julia> using BangBang

julia> deleteat!!((1, 2, 3), 2)
(1, 3)

julia> deleteat!!([1, 2, 3], 2)
2-element Array{Int64,1}:
 1
 3

julia> using StaticArrays: SVector

julia> @assert deleteat!!(SVector(1, 2, 3), 2) === SVector(1, 3)
```
"""
deleteat!!
deleteat!!(xs, key) = may(deleteat!, xs, key)

pure(::typeof(deleteat!)) = NoBang.deleteat
_asbb(::typeof(deleteat!)) = deleteat!!
possible(::typeof(deleteat!), ::C, ::Any) where C = implements(push!, C)

"""
    delete!!(assoc, key) -> assoc′

# Examples
```jldoctest
julia> using BangBang

julia> delete!!((a=1, b=2), :a)
(b = 2,)

julia> delete!!(Dict(:a=>1, :b=>2), :a)
Dict{Symbol,Int64} with 1 entry:
  :b => 2
```
"""
delete!!
delete!!(xs, key) = may(delete!, xs, key)

pure(::typeof(delete!)) = NoBang.delete
_asbb(::typeof(delete!)) = delete!!
possible(::typeof(delete!), ::C, ::Any) where C = implements(push!, C)

"""
    popfirst!!(sequence) -> (sequence′, value)

# Examples
```jldoctest
julia> using BangBang

julia> popfirst!!([0, 1])
([1], 0)

julia> popfirst!!((0, 1))
((1,), 0)

julia> popfirst!!((a=0, b=1))
((b = 1,), 0)

julia> using StaticArrays: SVector

julia> @assert popfirst!!(SVector(1, 2)) === (SVector(2), 1)
```
"""
popfirst!!
popfirst!!(xs) = may(_popfirst!, xs)
_popfirst!(xs) = xs, popfirst!(xs)

pure(::typeof(_popfirst!)) = NoBang.popfirst
possible(::typeof(_popfirst!), ::C,) where C = implements(push!, C)

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

julia> using StaticArrays: SVector

julia> @assert empty!!(SVector(1, 2)) == SVector{0, Int}()
```
"""
empty!!
empty!!(xs) = may(empty!, xs)

pure(::typeof(empty!)) = NoBang._empty
_asbb(::typeof(empty!)) = empty!!
possible(::typeof(empty!), ::C) where C = implements(push!, C)

"""
    mergewith!!(combine, dictlike, others...) -> dictlike′
    mergewith!!(combine)

Like `merge!!(combine, dictlike, others...)` but `combine` does not have
to be a `Function`.

This function "owns" `dictlike` but not `others`.  See
[`merge!!`](@ref) for more details.

The curried form `mergewith!!(combine)` returns the function
`(args...) -> mergewith!!(combine, args...)`.
"""
mergewith!!

mergewith!!(combine, dict, other) =
    foldl(pairs(other); init=dict) do dict, (k, v2)
        newdict, = Extras.modify!!(dict, k) do ans
            Some(ans === nothing ? v2 : combine(something(ans), v2))
        end
        return newdict
    end

mergewith!!(combine, dict, others...) = foldl(mergewith!!(combine), others; init = dict)
mergewith!!(combine) = MergeWith!!(combine)

struct MergeWith!!{F} <: Function
    combine::F
end

(f::MergeWith!!)(dict, others...) = mergewith!!(f.combine, dict, others...)

"""
    merge!!(dictlike, others...) -> dictlike′
    merge!!(combine, dictlike, others...) -> dictlike′

Merge key-value pairs from `others` to `dictlike`.  Mutate `dictlike`
if possible.

This function "owns" `dictlike` but not `others`; i.e., returned value
`dictlike′` does not alias any of `others`.  For example,
`merge!!(Empty(Dict), other)` shallow-copies `other` instead of
returning `other` as-is.

Method `merge!!(combine::Union{Function,Type}, args...)` as an alias
of `mergewith!!(combine, args...)` is still available for backward
compatibility.

See also [`mergewith!!`](@ref).

# Examples
```jldoctest
julia> using BangBang

julia> merge!!(Dict(:a => 1), Dict(:b => 0.5))
Dict{Symbol,Float64} with 2 entries:
  :a => 1.0
  :b => 0.5

julia> merge!!((a = 1,), Dict(:b => 0.5))
(a = 1, b = 0.5)

julia> merge!!(+, Dict(:a => 1), Dict(:a => 0.5))
Dict{Symbol,Float64} with 1 entry:
  :a => 1.5
```

`merge!!` does not own the second argument:

```jldoctest; setup = :(using BangBang)
julia> xs = Dict(:a => 1, :b => 2, :c => 3);

julia> ys = merge!!(Empty(Dict), xs)
Dict{Symbol,Int64} with 3 entries:
  :a => 1
  :b => 2
  :c => 3

julia> ys === xs
false
```
"""
merge!!
merge!!(dict, others...) = merge!!(right, dict, others...)
merge!!(combine::Base.Callable, dict, others...) =
    mergewith!!(combine, dict, others...)

right(_, x) = x

#=
"""
    splice!!(sequence, i, [replacement]) -> (sequence′, item)
    splice!!(sequence, range, [replacement]) -> (sequence′, items)
"""
=#

"""
    splice!!(sequence, i, [replacement]) -> (sequence′, item)

# Examples
```jldoctest
julia> using BangBang

julia> splice!!([1, 2, 3], 2)
([1, 3], 2)

julia> splice!!((1, 2, 3), 2)
((1, 3), 2)

julia> using StaticArrays: SVector

julia> @assert splice!!(SVector(1, 2, 3), 2) === (SVector(1, 3), 2)
```
"""
splice!!
splice!!(xs, args...) = may(_splice!, xs, args...)
_splice!(xs, args...) = xs, splice!(xs, args...)

pure(::typeof(_splice!)) = NoBang.splice
possible(::typeof(_splice!), ::C, ::Any) where C = implements(push!, C)
possible(::typeof(_splice!), xs::C, i::Integer, ::S) where {C, S} =
    possible(_splice!, xs, i) && promote_type(eltype(C), S) <: eltype(C)
possible(::typeof(_splice!), xs::C, i::Any, ::S) where {C, S} =
    possible(_splice!, xs, i) && promote_type(eltype(C), eltype(S)) <: eltype(C)

"""
    setindex!!(collection, value, indices...) -> collection′

# Examples
```jldoctest
julia> using BangBang

julia> setindex!!((1, 2), 10.0, 1)
(10.0, 2)

julia> setindex!!([1, 2], 10.0, 1)
2-element Array{Float64,1}:
 10.0
  2.0

julia> using StaticArrays: SVector

julia> @assert setindex!!(SVector(1, 2), 10.0, 1) == SVector(10.0, 2.0)
```
"""
setindex!!
Base.@propagate_inbounds setindex!!(xs, v, I...) = may(_setindex!, xs, v, I...)

Base.@propagate_inbounds _setindex!(xs, v, I...) = (setindex!(xs, v, I...); xs)

pure(::typeof(_setindex!)) = NoBang._setindex
possible(::typeof(_setindex!), ::Union{Tuple,NamedTuple,Empty}, ::Vararg) = false
possible(::typeof(_setindex!), ::C, ::T, ::Vararg) where {C <: AbstractArray, T} =
    implements(setindex!, C) && promote_type(eltype(C), T) <: eltype(C)
possible(::typeof(_setindex!), ::C, ::V, ::K) where {C <: AbstractDict, V, K} =
    implements(setindex!, C) &&
    promote_type(keytype(C), K) <: keytype(C) &&
    promote_type(valtype(C), V) <: valtype(C)

"""
    resize!!(vector::AbstractVector, n::Integer) -> vector′
"""
resize!!
resize!!(xs::Union{AbstractVector,Empty{<:AbstractVector}}, n::Integer) =
    implements(resize!, xs) ? resize!(xs, n) : NoBang.resize(xs, n)

pure(::typeof(resize!)) = NoBang.resize
_asbb(::typeof(resize!)) = resize!!

"""
    setproperties!!(value, patch::NamedTuple)
    setproperties!!(value; patch...)

# Examples
```jldoctest
julia> using BangBang

julia> setproperties!!((a=1, b=2); b=3)
(a = 1, b = 3)

julia> struct Immutable
           a
           b
       end

julia> setproperties!!(Immutable(1, 2); b=3)
Immutable(1, 3)

julia> mutable struct Mutable{T, S}
           a::T
           b::S
       end

julia> s = Mutable(1, 2);

julia> setproperties!!(s; b=3)
Mutable{Int64,Int64}(1, 3)

julia> setproperties!!(s, b=4.0)
Mutable{Int64,Float64}(1, 4.0)

julia> s
Mutable{Int64,Int64}(1, 3)
```
"""
@inline setproperties!!(value, patch) = may(setproperties!, value, patch)
@inline setproperties!!(value; patch...) = setproperties!!(value, (; patch...))

@inline function setproperties!(value, patch)
    for (k, v) in pairs(patch)
        setproperty!(value, k, v)
    end
    return value
end

@inline function setproperties!(value, patch::NamedTuple)
    ntuple(length(patch)) do i
        setproperty!(value, keys(patch)[i], patch[i])
    end
    return value
end

pure(::typeof(setproperties!)) = NoBang.setproperties
possible(::typeof(setproperties!), obj, patch) =
    implements(setproperty!, obj) && _is_compatible_field_types(obj, patch)

_is_compatible_field_types(::T, patch) where T =
    all(n -> fieldtype(typeof(patch), n) <: fieldtype(T, n), keys(patch))

@generated function _is_compatible_field_types(obj, patch::NamedTuple{pnames}) where pnames
    all(n -> fieldtype(patch, n) <: fieldtype(obj, n), pnames)
end

"""
    setproperty!!(value, name::Symbol, x)

An alias of `setproperties!!(value, (name=x,))`.
"""
setproperty!!
setproperty!!(value, name::Symbol, x) = setproperties!!(value, (; name => x))

"""
    materialize!!(dest, x)

```jldoctest
julia> using BangBang

julia> using Base.Broadcast: instantiate, broadcasted

julia> bc = instantiate(broadcasted(+, [1.0, 1.5, 2.0], 1));

julia> xs = zeros(Float64, 3);

julia> ys = materialize!!(xs, bc)
3-element Array{Float64,1}:
 2.0
 2.5
 3.0

julia> xs === ys  # mutated
true

julia> xs = Vector{Union{}}(undef, 3);

julia> ys = materialize!!(xs, bc)
3-element Array{Float64,1}:
 2.0
 2.5
 3.0

julia> xs === ys
false
```
"""
@inline materialize!!(dest, x) = may(_materialize!!, dest, x)
# TODO: maybe instantiate `x` and be aware of `x`'s style

@inline _materialize!!(dest, bc::Broadcasted{Style}) where {Style} =
    _copyto!!(dest, instantiate(Broadcasted{Style}(bc.f, bc.args, axes(dest))))

pure(::typeof(_materialize!!)) = NoBang.materialize
possible(::typeof(_materialize!!), ::Any, ::Any) = false
possible(::typeof(_materialize!!), x::AbstractArray, ::Any) = implements(push!, x)

@noinline throwdm(axdest, axsrc) =
    throw(DimensionMismatch("destination axes $axdest are not compatible with source axes $axsrc"))

# Based on default `copy(bc)` implementation
@inline function _copyto!!(dest, bc::Broadcasted)
    axes(dest) == axes(bc) || throwdm(axes(dest), axes(bc))

    ElType = combine_eltypes(bc.f, bc.args)
    # Use `copyto!` if we can trust the inference result:
    if ElType <: eltype(dest)
        return copyto!(dest, bc)
    elseif Base.isconcretetype(ElType)
        return copyto!(similar(bc, promote_typejoin(eltype(dest), ElType)), bc)
    end

    bc′ = preprocess(nothing, bc)
    iter = eachindex(bc′)
    y = iterate(iter)
    y === nothing && return dest

    # Try to store the first value
    I, state = y
    @inbounds val = bc′[I]
    if typeof(val) <: eltype(dest)
        dest′ = dest
    else
        dest′ = similar(bc′, typeof(val))
    end
    @inbounds dest′[I] = val

    # Handle the rest
    return copyto_nonleaf!(dest′, bc′, iter, state, 1)
end

"""
    unique!!(set) -> set
    unique!!(sequence) -> sequence′
"""
unique!!
unique!!(itr) = unique(itr)
unique!!(set::AbstractSet) = set
unique!!(xs::AbstractVector) = may(unique!, xs)

pure(::typeof(unique!)) = unique
_asbb(::typeof(unique!)) = unique!!
possible(::typeof(unique!), ::C) where {C} = implements(push!, C)

"""
    union!!(setlike, others...) -> setlike′

Return the union of all sets in the arguments.  Mutate `setlike` if
possible.

This function "owns" `setlike` but not `others`; i.e., returned value
`setlike′` does not alias any of `others`.  For example,
`union!!(Empty(Set), other)` shallow-copies `other` instead of
returning `other` as-is.

# Examples
```jldoctest
julia> using BangBang

julia> xs = Set([1]);

julia> ys = union!!(xs, Set([2]));  # mutates `xs` as it's possible

julia> ys == Set([1, 2])
true

julia> ys === xs  # `xs` is returned
true

julia> zs = union!!(xs, Set([0.5]));  # incompatible element type

julia> zs == Set([0.5, 1, 2])
true

julia> zs === xs  # a new set is returned
false
```

`union!!` does not own the second argument:

```jldoctest; setup = :(using BangBang)
julia> xs = Set([1]);

julia> ys = union!!(Empty(Set), xs)
Set{Int64} with 1 element:
  1

julia> ys === xs
false
```
"""
union!!
union!!(set, itr) = may(union!, set, itr)
union!!(set, itr, itrs...) = foldl(union!!, itrs, init = union!!(set, itr))

pure(::typeof(union!)) = NoBang._union
_asbb(::typeof(union!)) = union!!
possible(::typeof(union!), ::C, ::I) where {C<:Union{AbstractSet,AbstractVector},I} =
    implements(push!, C) &&
    IteratorEltype(I) isa HasEltype && promote_type(eltype(C), eltype(I)) <: eltype(C)
possible(::typeof(union!), ::Empty, ::Any) = false
