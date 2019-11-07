module SetfieldImpl

export @set!!, prefermutation

using ..BangBang: setproperty!!, setindex!!
using Setfield: ComposedLens,
                ConstIndexLens,
                DynamicIndexLens,
                IndexLens,
                Lens,
                PropertyLens,
                Setfield,
                set

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

const SupportedIndexLens = Union{ConstIndexLens,DynamicIndexLens,IndexLens}

indicesfor(lens::IndexLens, _) = lens.indices
indicesfor(::ConstIndexLens{I}, _) where {I} = I
indicesfor(lens::DynamicIndexLens, obj) = lens.f(obj)

Setfield.set(obj, lens::Lens!!{<:SupportedIndexLens}, value) =
    setindex!!(obj, value, indicesfor(lens.lens, obj)...)

"""
    prefermutation(lens::Lens) :: Lens

See also [`@set!!`](@ref).
"""
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
macro set!!(ex)
    Setfield.setmacro(prefermutation, ex, overwrite = true)
end

end  # module
