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
            # TODO: handle `x .* y`
            return Expr(:call, Expr(:call, _maybb, x.args[1]), x.args[2:end]...)
        elseif Meta.isexpr(x, :.=) && x.args[1] isa Symbol
            @assert length(x.args) == 2
            lhs, rhs = x.args
            return :($lhs = $materialize!!(
                $Base.@isdefined($lhs) ? $lhs : $(Undefined()),
                $rhs,
            ))
        end
        return x
    end |> esc
end

foldexpr(f, x) = x
foldexpr(f, ex::Expr) = f(Expr(ex.head, foldexpr.(f, ex.args)...))
