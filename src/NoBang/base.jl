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

@inline splice(xs::Tuple, i) = _splice_pre((), i - 1, xs...)

@inline _splice_pre(pre, n, x, xs...) =
    if length(pre) < n
        _splice_pre((pre..., x), n, xs...)
    else
        (pre..., xs...), x
    end

pop(xs::Tuple) = xs[1:end-1], xs[end]
pop(xs::NamedTuple{names}) where {names} =
    NamedTuple{names[1:end-1]}(xs[1:end-1]), xs[end]

maybepop(xs::NamedTuple, key) = maybepop(xs, Val(key))
maybepop(xs::NamedTuple{names}, ::Val{key}) where {names, key} =
    if haskey(xs, key)
        Some((Base.structdiff(xs, NamedTuple{(key,)}), xs[key]))
    else
        nothing
    end

pop(xs::NamedTuple, key, default) =
    something(maybepop(xs, key), Some((xs, default)))

function pop(xs::NamedTuple, key)
    result = maybepop(xs, key)
    result === nothing && throw(KeyError(key))
    return something(result)
end

popfirst(xs::Tuple) = xs[2:end], xs[1]
popfirst(xs::NamedTuple{names}) where {names} =
    NamedTuple{names[2:end]}(xs[2:end]), xs[1]

delete(xs::NamedTuple, key) = something(maybepop(xs, key), (xs,))[1]

_empty(xs) = empty(xs)
_empty(xs::NamedTuple) = NamedTuple()

setproperty(value, name, x) = setproperties(value, NamedTuple{(name,)}((x,)))
