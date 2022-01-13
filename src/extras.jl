"""
    BangBang.Extras

`BangBang` APIs that have no counterparts in `Base`.
"""
module Extras

export mergewith!!, modify!!, broadcast_inplace!!

using ..BangBang: delete!!, setindex!!, mergewith!!

"""
    modify!!(f, dictlike, key) -> (dictlike′, ret)

Lookup and then update, insert or delete in one go.  If supported
(e.g., when `dictlike isa Dict`), it is done without re-computing the
hash.  Immutable containers like `NamedTuple` is also supported.

The callable `f` must accept a single argument of type
`Union{Some{valtype(dictlike)}, Nothing}`.  The value
`Some(dictlike[key])` is passed to `f` if `haskey(dictlike, key)`;
otherwise `nothing` is passed.

If `f` returns `nothing`, corresponding entry in the dictionary
`dictlike` is removed.  If `f` returns non-`nothing` value `x`, `key
=> something(x)` is inserted to `dictlike` (equivalent to
`dictlike[key] = something(x)` but more efficient).

`modify!!` returns a 2-tuple `(dictlike′, ret)` where `dictlike′` is
an updated version of `dictlike` (which may be identical to
`dictlike`) and `ret` is the returned value of `f`.

This API is inspired by
[`Control.Lens.At`](http://hackage.haskell.org/package/lens-4.17.1/docs/Control-Lens-At.html)
of Haskell's lens library.

# Examples
```jldoctest
julia> using BangBang.Extras: modify!!

julia> dict = Dict("a" => 1);

julia> dict′, ret = modify!!(dict, "a") do val
           Some(something(val, 0) + 1)
       end;

julia> ret
Some(2)

julia> dict === dict′
true

julia> dict
Dict{String, Int64} with 1 entry:
  "a" => 2

julia> dict = Dict();

julia> modify!!(dict, "a") do val
           Some(something(val, 0) + 1)
       end;

julia> dict
Dict{Any, Any} with 1 entry:
  "a" => 1

julia> modify!!(_ -> nothing, dict, "a");

julia> dict
Dict{Any, Any}()
```

# Discussion

* [Add modify! function for lookup/update/insert/delete in one go by tkf · Pull Request #33758 · JuliaLang/julia](https://github.com/JuliaLang/julia/pull/33758)
* [Support adding to named tuples? · Issue #65 · jw3126/Setfield.jl](https://github.com/jw3126/Setfield.jl/issues/65)
"""
modify!!

modify!!(f, dict, key) = generic_modify!!(f, dict, key)

function generic_modify!!(f, dict, key)
    if haskey(dict, key)
        val = f(Some(dict[key]))
    else
        val = f(nothing)
    end
    if val === nothing
        dict′ = delete!!(dict, key)
    else
        dict′ = setindex!!(dict, something(val), key)
    end
    return (dict′, val)
end

function modify!!(f, h::Dict{K1}, key0::K2) where {K1, K2}
    promote_type(K1, K2) <: K1 || return generic_modify!!(f, h, key0)
    key = convert(K1, key0)
    isequal(key, key0) || return generic_modify!!(f, h, key0)

    # Ideally, to improve performance for the case that requires
    # resizing, we should use something like `ht_keyindex` while
    # keeping computed hash value and then do something like
    # `ht_keyindex2!` if `f` returns non-`nothing`.
    idx = Base.ht_keyindex2!(h, key)

    age0 = h.age
    found = false
    if idx > 0
        found = true
        @inbounds vold = h.vals[idx]
        vnew = f(Some(vold))
    else
        vnew = f(nothing)
    end
    if h.age != age0
        idx = Base.ht_keyindex2!(h, key)
    end

    if vnew === nothing
        if idx > 0
            Base._delete!(h, idx)
        end
    else
        val = something(vnew)
        if !(K1 isa String)
            if found && val === vold
                return (h, vnew)  # nothing to do (optimization)
            end
        end
        if !(typeof(val) <: eltype(h.vals))
            return setindex!!(h, val, key0), vnew
        end
        if idx > 0
            h.age += 1
            @inbounds h.keys[idx] = key
            @inbounds h.vals[idx] = val
        else
            @inbounds Base._setindex!(h, val, key, -idx)
        end
    end
    return (h, vnew)
end

function broadcast_inplace!! end

end  # module

# `Extras` was called `Experimental` before
const Experimental = Extras
