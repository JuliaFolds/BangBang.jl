"""
  @! expr

Convert all supported mutating calls to double bang equivalent.

# Examples
```jldoctest
julia> using BangBang

julia> @! push!(empty!((0, 1)), 2, 3)
(2, 3)
```
"""
macro !(expr)
    foldexpr(expr) do x
        if Meta.isexpr(x, :call)
            return Expr(:call, Expr(:call, _maybb, x.args[1]), x.args[2:end]...)
        end
        return x
    end |> esc
end

foldexpr(f, x) = x
foldexpr(f, ex::Expr) = f(Expr(ex.head, foldexpr.(f, ex.args)...))
