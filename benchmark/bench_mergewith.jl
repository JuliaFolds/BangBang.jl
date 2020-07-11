module BenchMergewith

using BangBang: mergewith!!, right
using BenchmarkTools: @benchmarkable, BenchmarkGroup

const suite = BenchmarkGroup()

src1 = Dict{Int,Int}(rand(Int, 1000) .=> 1)

for (clabel, cfun) in [:right => right, :+ => +]
    s0 = suite[:combine=>clabel] = BenchmarkGroup()

    s1 = s0[:desttype=>:compatible] = BenchmarkGroup()
    s1[:destkeys=>:empty] =
        @benchmarkable(mergewith!!($cfun, dest, $src1); setup = (dest = Dict{Int,Int}()))
    s1[:destkeys=>:equal] =
        @benchmarkable(mergewith!!($cfun, dest, $src1); setup = (dest = copy($src1)))
    s1[:destkeys=>:half] = @benchmarkable(
        mergewith!!($cfun, dest, $src1);
        setup = (dest = Dict{Int,Int}(collect(keys($src1))[1:end÷2] .=> 1))
    )

    s2 = s0[:desttype=>:widen] = BenchmarkGroup()
    s2[:destkeys=>:empty] =
        @benchmarkable(mergewith!!($cfun, dest, $src1); setup = (dest = Dict{Bool,Int}()))
end

end  # module
BenchMergewith.suite
