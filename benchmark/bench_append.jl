module BenchAppend

using BangBang: Empty, append!!, empty!!
using BangBang.NoBang: SingletonVector
using BenchmarkTools: @benchmarkable, BenchmarkGroup
using StaticArrays: SVector

function repeat_append!(dest, src, n_repeat = 100, n_values = 1000)
    for _ = 1:n_repeat
        x = empty!!(dest)
        for _ in 1:n_values
            append!!(x, src)
        end
    end
end

repeat_append(dest, src) =
    foldl(append!!, ntuple(_ -> src, 10); init = dest)

suite = BenchmarkGroup()
suite["append!!(::Vector, ::SingletonVector)"] =
    @benchmarkable(repeat_append!($(Float64[]), SingletonVector(1.0)))
suite["append!!(::SVector, ::SingletonVector)"] =
    @benchmarkable(repeat_append(SVector{0,Float64}(), SingletonVector(1.0)))
suite["append!!(Empty(SVector), ::SingletonVector)"] =
    @benchmarkable(repeat_append(Empty(SVector), SingletonVector(1.0)))

end  # module
BenchAppend.suite
