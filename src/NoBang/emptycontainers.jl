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
1-element Array{Int64,1}:
 1

julia> append!!(Empty(Dict), (:a=>1, :b=>2))
Dict{Symbol,Int64} with 2 entries:
  :a => 1
  :b => 2

julia> using DataFrames: DataFrame

julia> @assert push!!(Empty(DataFrame), (a=1, b=2)) == DataFrame(a=[1], b=[2])

julia> using StructArrays: StructVector

julia> @assert push!!(Empty(StructVector), (a=1, b=2)) == StructVector(a=[1], b=[2])

julia> using TypedTables: Table

julia> @assert push!!(Empty(Table), (a=1, b=2)) == Table(a=[1], b=[2])
```

`Empty(T)` object is an iterable with length 0 and element type `Union{}`:

```jldoctest; setup=:(using BangBang)
julia> collect(Empty(Vector))
0-element Array{Union{},1}

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

Base.IteratorSize(::Type{<:Empty}) = Base.HasLength()
Base.IteratorEltype(::Type{<:Empty}) = Base.HasEltype()
Base.eltype(::Type{<:Empty}) = Union{}
Base.length(::Empty) = 0
Base.iterate(::Empty) = nothing
