"""
    mul!!(C, A, B) -> C′
"""
mul!!(C, A, B) = may(mul!, C, A, B)

pure(::typeof(mul!)) = NoBang.mul
_asbb(::typeof(mul!)) = mul!!
possible(::typeof(mul!), C, ::Any, ::Any) = ismutable(C)

"""
    lmul!!(A, B) -> B′
"""
lmul!!(A, B) = may(lmul!, A, B)

pure(::typeof(lmul!)) = *
_asbb(::typeof(lmul!)) = lmul!!
possible(::typeof(lmul!), ::Any, B) = ismutable(B)

"""
    rmul!!(A, B) -> A′
"""
rmul!!(A, B) = may(rmul!, A, B)

pure(::typeof(rmul!)) = *
_asbb(::typeof(rmul!)) = rmul!!
possible(::typeof(rmul!), A, ::Any) = ismutable(A)
