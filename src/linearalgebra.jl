mul!!(C, A, B) = may(mul!, C, A, B)

possible(::typeof(mul!), C, ::Any, ::Any) = ismutable(C)
