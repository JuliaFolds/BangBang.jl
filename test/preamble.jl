import Pkg
using Test
using Base: ImmutableDict
using BangBang
using BangBang: implements
using StaticArrays: SVector

"""
    ==ₜ(x, y)

Check that _type_ and value of `x` and `y` are equal.
"""
==ₜ(_, _) = false
==ₜ(x::T, y::T) where T = x == y

macro test_error(ex)
    quote
        let err = nothing
            try
                $(esc(ex))
            catch err
            end
            @test err isa Exception
            err
        end
    end
end

macro test_inferred(ex)
    esc(:($Test.@test (($Test.@inferred $ex); true)))
end

"""
    @test_returns_first f(x, ...) ==′ rhs

It is transformed
    @test f((tmp = x; tmp), ...) === tmp ==′ rhs
"""
macro test_returns_first(ex)
    Meta.isexpr(ex, :call, 3) || error("need `lhs cmp rhs`; got:\n$ex")
    c, l, r = ex.args
    (Meta.isexpr(l, :call) && length(l.args) > 1)|| error("lhs should be a call; got:\n$l")
    a = l.args[2]
    @gensym x
    l.args[2] = quote
        $x = $a
        $x
    end
    cmp = Expr(:comparison, l, :(===), x, c, r)
    quote
        $Test.@test $cmp
    end |> esc
end

versionof(pkg::Module) = versionof(Base.PkgId(pkg))
if isdefined(Pkg, :dependencies)
    versionof(pkg::Base.PkgId) = Pkg.dependencies()[pkg.uuid].version
else
    versionof(pkg::Base.PkgId) = Pkg.installed()[pkg.name]
end
