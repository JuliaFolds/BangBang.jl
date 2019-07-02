may(mutate, args...) =
    if possible(mutate, args...)
        mutate(args...)
    else
        pure(mutate)(args...)
    end

function _setproperty!(value, name, x)
    setproperty!(value, name, x)
    return value
end

pure(::typeof(push!)) = NoBang.push
pure(::typeof(append!)) = NoBang.append
pure(::typeof(pushfirst!)) = NoBang.pushfirst
pure(::typeof(_setproperty!)) = NoBang.setproperty
pure(::typeof(mul!)) = NoBang.mul

const MaybeMutableContainer = Union{
    AbstractArray,
    AbstractDict,
    AbstractSet,
}

ismutable(x) = ismutable(typeof(x))
ismutable(::Type) = false
ismutable(::Type{<:ImmutableContainer}) = false
ismutable(::Type{<:MaybeMutableContainer}) = true
ismutable(::Type{<:AbstractString}) = false

ismutablestruct(x) = ismutablestruct(typeof(x))
Base.@pure ismutablestruct(T::DataType) = T.mutable
ismutablestruct(::Type{<:NamedTuple}) = false

# trymutate(::typeof(push!)) = push!!
# trymutate(::typeof(append!)) = append!!
