mul!!(C, A, B) = may(mul!, C, A, B)

pure(::typeof(mul!)) = NoBang.mul
_asbb(::typeof(mul!)) = mul!!
possible(::typeof(mul!), C, ::Any, ::Any) = ismutable(C)
