const ImmutableContainer = Union{
    ImmutableDict,
    NamedTuple,
    Tuple,
}

push(xs, i1, i2, items...) =
    foldl(push, items, init=push(push(xs, i1), i2))

push(xs::AbstractVector, x) = vcat(xs, SingletonVector(x))
push(xs::AbstractSet, x) = union(xs, SingletonVector(x))
push(xs::AbstractDict, x::Pair) = merge(xs, SingletonDict(x[1], x[2]))

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

function pushfirst(xs::AbstractVector, ys...)
    T = promote_type(eltype(xs), map(typeof, ys)...)
    zs = similar(xs, T, length(xs) + length(ys))
    copyto!(zs, length(ys) + 1, xs, 1, length(xs))
    copyto!(zs, 1, ys, 1, length(ys))
    return zs
end

pushfirst(xs::Tuple, ys...) = (ys..., xs...)
setproperty(value, name, x) = setproperties(value, NamedTuple{(name,)}((x,)))
