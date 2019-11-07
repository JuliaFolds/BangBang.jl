# Helper types for implementing `push`


struct SingletonVector{T} <: AbstractVector{T}
    value::T
end

Base.size(::SingletonVector) = (1,)

function Base.getindex(v::SingletonVector, i::Integer)
    @boundscheck i == 1 || throw(BoundsError(v, i))
    return v.value
end

# Define table interface as a `SingletonVector{<:NamedTuple}`:
Tables.istable(::Type{<:SingletonVector{<:NamedTuple{names}}}) where {names} =
    @isdefined(names)
Tables.rowaccess(::Type{<:SingletonVector{<:NamedTuple{names}}}) where {names} =
    @isdefined(names)
Tables.columnaccess(::Type{<:SingletonVector{<:NamedTuple{names}}}) where {names} =
    @isdefined(names)

Tables.rows(x::SingletonVector{<:NamedTuple}) = [x.value]
Tables.columns(x::SingletonVector{<:NamedTuple{names}}) where {names} =
    NamedTuple{names}(map(x -> [x], Tuple(x.value)))


struct SingletonDict{K,V} <: AbstractDict{K,V}
    key::K
    value::V
end

Base.iterate(d::SingletonDict) = (d.key => d.value, nothing)
Base.iterate(d::SingletonDict, ::Nothing) = nothing

function Base.getindex(d::SingletonDict{K}, key::K) where {K}
    @boundscheck d.key == key || throw(BoundsError(d, key))
    return d.value
end

Base.length(::SingletonDict) = 1
