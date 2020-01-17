# Helper types for implementing `push`


struct SingletonVector{T} <: AbstractVector{T}
    value::T
end

Base.size(::SingletonVector) = (1,)
Base.first(v::SingletonVector) = v.value
Base.last(v::SingletonVector) = v.value

function Base.getindex(v::SingletonVector, i::Integer)
    @boundscheck i == 1 || throw(BoundsError(v, i))
    return v.value
end

Base.append!(dest::AbstractVector, v::SingletonVector) = push!(dest, v.value)
Base.append!(dest::Vector, v::SingletonVector) = push!(dest, v.value)  # disambiguation

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

SingletonDict((key, value)::Pair) = SingletonDict(key, value)

Base.iterate(d::SingletonDict) = (d.key => d.value, nothing)
Base.iterate(d::SingletonDict, ::Nothing) = nothing

Base.first(d::SingletonDict) = d.key => d.value
Base.last(d::SingletonDict) = d.key => d.value

function Base.getindex(d::SingletonDict{K}, key::K) where {K}
    @boundscheck d.key == key || throw(BoundsError(d, key))
    return d.value
end

Base.length(::SingletonDict) = 1
