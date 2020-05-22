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
const Mutator = Union{typeof(push!), typeof(setindex!)}

"""
    implements(f!, x) :: Bool

`true` if in-place function `f!` can mutate `x`.

# Examples
```jldoctest
julia> using BangBang: implements

julia> implements(push!, Vector)
true

julia> implements(push!, [])  # works with instances, too
true

julia> implements(push!, Tuple)
false

julia> using StaticArrays

julia> implements(push!, SVector)
false

julia> implements(setindex!, SVector)
false

julia> implements(push!, MVector)
false

julia> implements(setindex!, MVector)
true
```
"""
implements(f!, x) = implements(f!, typeof(x))
implements(::Any, ::Type) = false

implements(::Mutator, ::Type{<:ImmutableContainer}) = false
implements(::Mutator, ::Type{<:MaybeMutableContainer}) = true
implements(::Mutator, ::Type{<:AbstractString}) = false

implements(::typeof(resize!), ::Type{<:AbstractVector}) = true
implements(
    ::typeof(resize!),
    ::Type{<:Union{SubArray{<:Any,1},Base.ReshapedArray{<:Any,1}}},
) = false

Base.@pure ismutablestruct(T::DataType) = T.mutable
implements(::typeof(setproperty!), T::DataType) = ismutablestruct(T)
implements(::typeof(setproperty!), ::Type{<:NamedTuple}) = false

# trymutate(::typeof(push!)) = push!!
# trymutate(::typeof(append!)) = append!!

struct Undefined end
implements(::Mutator, ::Undefined) = false

"""
    possible(f!, args...) :: Bool

Check if `f!(args...)` is possible.

# Examples
```jldoctest
julia> using BangBang: possible

julia> possible(push!, Int[], 1)
true

julia> possible(push!, Int[], 0.5)
false
```
"""
possible
