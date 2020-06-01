"""
    collector(data::AbstractVector, unsafe::Val = Val(false)) -> c::AbstractCollector
    collector(ElType::Type = Union{}) -> c::AbstractCollector

Create a "collector" `c` that can be used to collect elements; i.e.,
it supports [`append!!`](@ref) and [`push!!`](@ref).  Appending and
pushing elements to a collector are more efficient than doing these
operations directly to a vector.

Use [`finish!(c)`](@ref finish!) to get the collected data as a vector.

`push!!` on the collector can be further optimized by passing
`Val(true)` to the second `unsafe` argument.  This is valid to use
only if the number of elements appended to `c` is less than or equal
to `length(data)`.

# Examples
```jldoctest
julia> using BangBang

julia> c = collector()
       c = push!!(c, 1)
       c = push!!(c, 0.5)
       finish!(c)
2-element Array{Float64,1}:
 1.0
 0.5

julia> finish!(append!!(collector(), (x for x in Any[1, 2.0, 3im])))
3-element Array{Complex{Float64},1}:
 1.0 + 0.0im
 2.0 + 0.0im
 0.0 + 3.0im

julia> finish!(append!!(collector(Vector{Float64}(undef, 10), Val(true)), [1, 2, 3]))
3-element Array{Float64,1}:
 1.0
 2.0
 3.0
```
"""
collector
collector(data::AbstractArray, ::Val{false} = Val(false)) = SafeCollector(data)
collector(data::AbstractArray, ::Val{true}) = UnsafeCollector(data)
collector(ElType::Type = Union{}) = SafeCollector(Empty(Vector{ElType}), 1)

abstract type AbstractCollector end

struct SafeCollector{T} <: AbstractCollector
    data::T
    i::Int
end

struct UnsafeCollector{T} <: AbstractCollector
    data::T
    i::Int
end

(::Type{C})(data::AbstractVector) where {C<:AbstractCollector} = C(data, firstindex(data))

# If `c isa UnsafeCollector` and `v` is promotable to
# `eltype(c.data)`, this should compile down to `setindex!`:
@inline push!!(c::AbstractCollector, v) =
    _collect_to!!(c, SingletonVector(v), Base.HasShape{1}(), Base.HasEltype())

@inline __append!!__(c::AbstractCollector, src) =
    _collect_to!!(c, src, Base.IteratorSize(src), Base.IteratorEltype(src))

# ref: jl_array_grow_at_end
_next_length(data, src) = max(4, length(data) + length(src), length(data) * 2)

@inline function _collect_to!!(
    c::AbstractCollector,
    src,
    ::Union{Base.HasShape,Base.HasLength},
    ::Base.HasEltype,
)
    data = c.data
    i = c.i
    if possible(_append!, data, src)
        if c isa UnsafeCollector
            data′ = data
        elseif i + length(src) - 1 > lastindex(data)
            data′ = resize!!(data, _next_length(data, src))
        else
            data′ = data
        end
    else
        T = promote_type(eltype(data), eltype(src))
        if i + length(src) - 1 > lastindex(data)
            data′ = similar(data, T, _next_length(data, src))
        else
            data′ = similar(data, T)
        end
        copyto!(data′, firstindex(data), data, firstindex(data), i - firstindex(data))
    end
    i = let data′ = data′
        foldl(src, init = i) do i, v
            Base.@_inline_meta
            @inbounds data′[i] = v
            return i + 1
        end
    end
    return constructorof(typeof(c))(data′, i)
end

@inline function _collect_to!!(
    c::AbstractCollector,
    src,
    ::Union{Base.HasShape,Base.HasLength},
    ::Base.IteratorEltype,
)
    if c isa UnsafeCollector
        data′′ = c.data
    elseif c.i + length(src) - 1 > lastindex(c.data)
        data′′ = resize!!(c.data, _next_length(c.data, src))
    else
        data′′ = c.data
    end
    data, i = foldl(src, init = (data′′, c.i)) do (data, i), v
        Base.@_inline_meta
        T = promote_type(eltype(data), eltype(v))
        if T <: eltype(data)
            data′ = data
        else
            data′ = similar(data, T)
            copyto!(data′, firstindex(data), data, firstindex(data), i - firstindex(data))
        end
        @inbounds data′[i] = v
        return data′, i + 1
    end
    return constructorof(typeof(c))(data, i)
end

@inline _collect_to!!(
    c::AbstractCollector,
    src,
    ::Base.IteratorSize,
    ::Base.IteratorEltype,
) = foldl(push!!, src, init = c)

@inline __append!!__(c::AbstractCollector, src::AbstractCollector) =
    __append!!__(c, _view(src))

_view(c::AbstractCollector) = @inbounds view(c.data, firstindex(c.data):c.i-1)

"""
    finish!(c::AbstractCollector) -> data::AbstractVector

Extract the `data` collected in the collector `c`.

See [`collector`](@ref).
"""
finish!
finish!(c::AbstractCollector) = resize!!(c.data, c.i - firstindex(c.data))
# Final length is `(c.i - 1) - (firstindex(c.data) - 1)` where the
# first `- 1` is because `c.i` is the index for the next element and
# the second `- 1` is for turning the index to offset.
