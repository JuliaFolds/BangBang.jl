"""
    add!!(A, B) -> A′

`A .+= B` if possible; otherwise return `A .+ B`.

# Examples
```jldoctest
julia> using BangBang: add!!

julia> add!!((1,), (2,))
(3,)

julia> add!!([1], [2])
1-element Vector{Int64}:
 3
```
"""
add!!
add!!(A, B) = materialize!!(A, instantiate(broadcasted(+, A, B)))

"""
    mul!!(C, A, B, [α, β]) -> C′
"""
mul!!
mul!!(C, A, B) = may(mul!, C, A, B)
mul!!(C, A, B, α, β) = may(mul!, C, A, B, α, β)

pure(::typeof(mul!)) = NoBang.mul
_asbb(::typeof(mul!)) = mul!!
possible(::typeof(mul!), C, A, B) =
    implements(push!, C) && _matmuleltype(A, B) <: eltype(C)
possible(::typeof(mul!), C, A, B, α, β) =
    implements(push!, C) && _matmuleltype(C, A, B, α, β) <: eltype(C)

# Estimate `eltype` of `C`.  This is somewhat based on the approach of
# https://github.com/tpapp/AlgebraResultTypes.jl and `matprod` in
# LinearAlgebra.jl.

@inline _matprodtype(x, y) = typeof(x * y + x * y)
@inline _matprodtype(c, a, b, α, β) = typeof(a * b * α + a * b * α + c * β)

function _matmuleltype(A, B)
    a = eltype(A)
    b = eltype(B)
    isconcretetype(a) || return Any
    isconcretetype(b) || return Any
    return _matprodtype(one(a), one(b))
end

function _matmuleltype(C, A, B, α, β)
    a = eltype(A)
    b = eltype(B)
    c = eltype(C)
    return _matprodtype(one(c), one(a), one(b), α, β)
end

"""
    lmul!!(A, B) -> B′
"""
lmul!!
lmul!!(A, B) = may(lmul!, A, B)

pure(::typeof(lmul!)) = *
_asbb(::typeof(lmul!)) = lmul!!
possible(::typeof(lmul!), A, B) =
    implements(push!, B) && _matmuleltype(A, B) <: eltype(B)

"""
    rmul!!(A, B) -> A′
"""
rmul!!
rmul!!(A, B) = may(rmul!, A, B)

pure(::typeof(rmul!)) = *
_asbb(::typeof(rmul!)) = rmul!!
possible(::typeof(rmul!), A, B) =
    implements(push!, A) && _matmuleltype(A, B) <: eltype(A)
