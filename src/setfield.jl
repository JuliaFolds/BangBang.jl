module SetfieldImpl

export @set!!, prefermutation

using ..BangBang: setproperty!!, setindex!!
using Setfield: ComposedLens, DynamicIndexLens, IndexLens, Lens, PropertyLens, Setfield, set

struct Lens!!{T<:Lens} <: Lens
    lens::T
end

Setfield.get(obj, lens::Lens!!) = get(obj, lens.lens)

# Default to immutable:
Setfield.set(obj, lens::Lens!!, value) = set(obj, lens.lens, value)

Setfield.set(obj, lens::Lens!!{<:ComposedLens}, value) =
    set(obj, Lens!!(lens.lens.outer) ∘ Lens!!(lens.lens.inner), value)

Setfield.set(obj, ::Lens!!{<:PropertyLens{fieldname}}, value) where {fieldname} =
    setproperty!!(obj, fieldname, value)

indicesfor(lens::IndexLens, _) = lens.indices
indicesfor(lens::DynamicIndexLens, obj) = lens.f(obj)

if isdefined(Setfield, :ConstIndexLens)
    using Setfield: ConstIndexLens
    const SupportedIndexLens = Union{ConstIndexLens,DynamicIndexLens,IndexLens}
    indicesfor(::ConstIndexLens{I}, _) where {I} = I
else
    const SupportedIndexLens = Union{DynamicIndexLens,IndexLens}
end

Setfield.set(obj, lens::Lens!!{<:SupportedIndexLens}, value) =
    setindex!!(obj, value, indicesfor(lens.lens, obj)...)

"""
    prefermutation(lens::Lens) :: Lens

See also [`@set!!`](@ref).
"""
prefermutation
prefermutation(lens::Lens) = Lens!!(lens)

"""
    @set!! assignment

Like `Setfield.@set`, but prefer mutation if possible.

# Examples
```jldoctest
julia> using BangBang

julia> mutable struct Mutable
           a
           b
       end

julia> x = orig = Mutable((x=Mutable(1, 2), y=3), 4);

julia> @set!! x.a.x.a = 10;

julia> @assert x.a.x.a == orig.a.x.a == 10
```
"""
:(@set!!)
macro set!!(ex)
    Setfield.setmacro(prefermutation, ex, overwrite = true)
end

end  # module
