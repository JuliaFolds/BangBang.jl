module Experimental

export mergewith!!

using ..BangBang: setindex!!

struct _NoValue end

"""
    mergewith!!(combine, dict, others...) -> dict′
    mergewith!!(combine)

Like `merge!!(combine, dict, others...)` but `combine` does not have
to be a `Function`.

The curried form `mergewith!!(combine)` returns the function
`(args...) -> mergewith!!(combine, args...)`.

See also:
[Add `mergewith[!](combine, dicts...)` by tkf · Pull Request #34296 · JuliaLang/julia](https://github.com/JuliaLang/julia/pull/34296)
"""
mergewith!!

mergewith!!(combine, dict, other) =
    foldl(pairs(other); init=dict) do dict, (k, v2)
        v1 = get(dict, k, _NoValue())
        setindex!!(dict, v1 isa _NoValue ? v2 : combine(v1, v2), k)
    end

mergewith!!(combine, dict, others...) =
    foldl(others; init=dict) do dict, other
        mergewith!!(combine, dict, other)
    end

mergewith!!(combine) = (args...) -> mergewith!!(combine, args...)

end  # module
