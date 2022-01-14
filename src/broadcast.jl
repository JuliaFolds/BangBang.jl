"""
    broadcast!!(f, dest, As...) -> dest′

A mutate-or-widen version of `dest .= f.(As...)`.
"""
broadcast!!
@inline broadcast!!(f::F, dest, As...) where {F} =
    materialize!!(dest, instantiate(broadcasted(f, As...)))

"""
    broadcast_inplace!!(f, inputoutput, As...) -> inputoutput′

A mutate-or-widen version of `inputoutput .= f.(inputoutput, As...)`.
"""
Extras.broadcast_inplace!!
@inline Extras.broadcast_inplace!!(f::F, inputoutput, As...) where {F} =
    materialize!!(inputoutput, instantiate(broadcasted(f, inputoutput, As...)))
