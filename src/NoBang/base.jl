const ImmutableContainer = Union{
    ImmutableDict,
    NamedTuple,
    Tuple,
}

push(xs, i1, i2, items...) =
    foldl(push, items, init=push(push(xs, i1), i2))

# A helper type for implementing `push`
struct SingletonVector{T} <: AbstractVector{T}
    value::T
end

Base.size(::SingletonVector) = (1,)

function Base.getindex(v::SingletonVector, i::Integer)
    @boundscheck i == 1 || throw(BoundsError(v, i))
    return v.value
end

push(xs::AbstractVector, x) = vcat(xs, SingletonVector(x))

push(xs::Tuple, items...) = (xs..., items...)

push(xs::NamedTuple{names}, x::Pair{Symbol}) where {names} =
    NamedTuple{(names..., x.first)}((xs..., x.second))

push(xs::NamedTuple{names}, x::Pair{Val{name}}) where {names, name} =
    NamedTuple{(names..., name)}((xs..., x.second))

push(::NamedTuple, x) =
    error("`push(::NamedTuple, x::$(typeof(x)))` is not supported.\n",
          "Use `push(::NamedTuple, :NAME => x)` or ",
          "`push(::NamedTuple, Val(:NAME) => x)`.")

push(xs::ImmutableDict, x::Pair) = ImmutableDict(xs, x)

append(xs, ys) = _append(xs, ys)
_append(xs, ys) = append!(copy(xs), ys)
_append(xs, ys::Tuple) = push(xs, ys...)
_append(xs, ys::Pairs{Symbol, <:Any, <:Any, <:NamedTuple}) = push(xs, ys...)

append(xs::ImmutableContainer, ys) = push(xs, ys...)

setproperty(value, name, x) = setproperties(value, NamedTuple{(name,)}((x,)))
