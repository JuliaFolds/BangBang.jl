"""
    singletonof(::Type{T}, x) :: T
    singletonof(::T, x) :: T

Create a singleton container of type `T`.

# Examples
```jldoctest
julia> using BangBang

julia> @assert singletonof(Vector, 1) == [1]

julia> @assert singletonof(Dict, :a => 1) == Dict(:a => 1)

julia> @assert singletonof(Set, 1) == Set([1])

julia> using StructArrays: StructVector

julia> @assert singletonof(StructVector, (a=1, b=2)) == StructVector(a=[1], b=[2])

julia> using TypedTables: Table

julia> @assert singletonof(Table, (a=1, b=2)) == Table(a=[1], b=[2])
```
"""
singletonof(::Type{T}, x) where {T} =
    T(SingletonVector(_maybeasnamedtuple(x, T)))

function singletonof(::T, x) where T
    C = constructorof(T)
    return singletonof(C isa Type ? C : T, _maybeasnamedtuple(x, T))
end
# `StructVector` is a table but `StructArray` is not.  So, converting
# to a named tuple before stripping off the type parameters.

asnamedtuple(x::NamedTuple) = x
asnamedtuple(x) = (; map(n -> n => getproperty(x, n), propertynames(x))...)

_maybeasnamedtuple(x, T) = Tables.istable(T) ? asnamedtuple(x) : x
