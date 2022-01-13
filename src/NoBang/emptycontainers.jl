"""
    Empty(T)

Create a proxy of an empty container of type `T`.

This is a simple API for solving problems such as:

* There is no consistent way to create an empty container given its type.
* There is no consistent way to know that nothing was appended into the
  container in type-domain.

Internally, this function simply works by creating a singleton container
(a container with one element) using [`singletonof`](@ref) when the first
element is [`push!!`](@ref)'ed.

# Examples
```jldoctest
julia> using BangBang

julia> push!!(Empty(Vector), 1)
1-element Vector{Int64}:
 1

julia> append!!(Empty(Dict), (:a=>1, :b=>2))
Dict{Symbol, Int64} with 2 entries:
  :a => 1
  :b => 2

julia> using DataFrames: DataFrame

julia> @assert push!!(Empty(DataFrame), (a=1, b=2)) == DataFrame(a=[1], b=[2])

julia> using StructArrays: StructVector

julia> @assert push!!(Empty(StructVector), (a=1, b=2)) == StructVector(a=[1], b=[2])

julia> using TypedTables: Table

julia> @assert push!!(Empty(Table), (a=1, b=2)) == Table(a=[1], b=[2])

julia> using StaticArrays: SVector

julia> @assert push!!(Empty(SVector), 1) === SVector(1)
```

`Empty(T)` object is an iterable with length 0 and element type `Union{}`:

```jldoctest; setup=:(using BangBang)
julia> collect(Empty(Vector))
Union{}[]

julia> length(Empty(Vector))
0

julia> eltype(typeof(Empty(Vector)))
Union{}

julia> Base.IteratorSize(Empty)
Base.HasLength()

julia> Base.IteratorEltype(Empty)
Base.HasEltype()
```
"""
struct Empty{T} end
Empty(T::Type) = Empty{T}()

push(::Empty{T}, x) where T = singletonof(T, x)
append(::Empty{T}, x) where T = T(x)
# In `append`, it is assumed that `T(x::Vector)` works (as done in the
# implementation of `singletonof`).

append(e::Empty, ::Empty) = e

_empty(x::Empty) = x
resize(::Empty{T}, n::Integer) where {T <: AbstractVector} = similar(T, (n,))

_union(::Empty{T}, x) where {T} = unique!!(T(x))
_union(e::Empty, ::Empty) = e

_setdiff(x::Empty, _) = x

_setindex(::Empty{T}, v, k) where {T <: AbstractDict} = T(SingletonDict(k, v))
Base.get(::Empty, _, default) = default

Base.IteratorSize(::Type{<:Empty}) = Base.HasLength()
Base.IteratorEltype(::Type{<:Empty}) = Base.HasEltype()
Base.eltype(::Type{<:Empty}) = Union{}
Base.eltype(::Type{<:Empty{<:AbstractVector{T}}}) where {T} = T
Base.length(::Empty) = 0
Base.iterate(::Empty) = nothing
Base.haskey(::Empty, ::Any) = false

Base.firstindex(::Empty{<:Vector}) = 1
Base.lastindex(::Empty{<:Vector}) = 0
Base.similar(e::Empty) = similar(e, eltype(e), (0,))
Base.similar(e::Empty, dims::Int...) = similar(e, eltype(e), dims)
Base.similar(e::Empty, dims::Tuple{Vararg{Int}}) = similar(e, eltype(e), dims)
Base.similar(e::Empty, T::Type) = similar(e, T, (0,))
Base.similar(e::Empty, T::Type, dims::Int...) = similar(e, T, dims)
Base.similar(::Empty{<:Vector}, T::Type, dims::Tuple{Vararg{Int}}) =
    similar(Vector{T}, dims)
Base.similar(::Empty{Vector{T}}, dims::Tuple{Vararg{Int}}) where {T} =
    similar(Vector{T}, dims)
