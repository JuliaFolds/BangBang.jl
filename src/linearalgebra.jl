"""
    mul!!(C, A, B) -> C′
"""
mul!!(C, A, B) = may(mul!, C, A, B)

pure(::typeof(mul!)) = NoBang.mul
_asbb(::typeof(mul!)) = mul!!
possible(::typeof(mul!), C, A, B) =
    ismutable(C) && _matmuleltype(A, B) <: eltype(C)

# Estimate `eltype` of `C`.  This is how it's done in LinearAlgebra.jl
# but maybe it's better to use the approach of
# https://github.com/tpapp/AlgebraResultTypes.jl ?
_matprod(x, y) = x * y + x * y
_matmuleltype(A, B) = Base.promote_op(_matprod, eltype(A), eltype(B))

"""
    lmul!!(A, B) -> B′
"""
lmul!!(A, B) = may(lmul!, A, B)

pure(::typeof(lmul!)) = *
_asbb(::typeof(lmul!)) = lmul!!
possible(::typeof(lmul!), A, B) =
    ismutable(B) && _matmuleltype(A, B) <: eltype(B)

"""
    rmul!!(A, B) -> A′
"""
rmul!!(A, B) = may(rmul!, A, B)

pure(::typeof(rmul!)) = *
_asbb(::typeof(rmul!)) = rmul!!
possible(::typeof(rmul!), A, B) =
    ismutable(A) && _matmuleltype(A, B) <: eltype(A)
