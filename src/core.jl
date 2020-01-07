"""
    may(mutate!, args...)

Call `mutate!(args...)` if possible; fallback to the out-of-place version if not.
"""
Base.@propagate_inbounds may(mutate, args...) =
    if possible(mutate, args...)
        mutate(args...)
    else
        pure(mutate)(args...)
    end

_maybb(mutate) = something(_asbb(mutate), mutate)
_asbb(::Any) = nothing

const MaybeMutableContainer = Union{
    AbstractArray,
    AbstractDict,
    AbstractSet,
}

"""
    implements(f!, x) :: Bool

`true` if in-place function `f!` can mutate `x`.
"""
implements(f!, x) = implements(f!, typeof(x))
implements(::Any, ::Type) = false

implements(::typeof(push!), ::Type{<:ImmutableContainer}) = false
implements(::typeof(push!), ::Type{<:MaybeMutableContainer}) = true
implements(::typeof(push!), ::Type{<:AbstractString}) = false

"""
    ismutablestruct(x)

`true` if `x` is mutable as a struct/object.
"""
ismutablestruct(x) = ismutablestruct(typeof(x))
Base.@pure ismutablestruct(T::DataType) = T.mutable
ismutablestruct(::Type{<:NamedTuple}) = false

# trymutate(::typeof(push!)) = push!!
# trymutate(::typeof(append!)) = append!!

struct Undefined end
implements(::typeof(push!), ::Undefined) = false
