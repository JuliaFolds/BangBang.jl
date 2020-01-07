implements(::typeof(push!), ::Type{<:StaticArrays.StaticArray}) = false
implements(::typeof(push!), ::Type{<:StaticArrays.MArray}) = true
