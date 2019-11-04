"""
    singletonof(::Type{T}, x) :: T

Create a singleton container of type `T`.

# Examples
```jldoctest
julia> using BangBang

julia> @assert singletonof(Vector, 1) == [1]

julia> @assert singletonof(Dict, :a => 1) == Dict(:a => 1)

julia> @assert singletonof(Set, 1) == Set([1])

julia> using StructArrays: StructVector

julia> @assert singletonof(StructVector, (a=1, b=2)) == StructVector(a=[1], b=[2])
```
"""
singletonof(::Type{T}, x) where T = T(SingletonVector(x))
