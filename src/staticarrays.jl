ismutable(::Type{<:StaticArrays.StaticArray}) = false
ismutable(::Type{<:StaticArrays.MArray}) = true
