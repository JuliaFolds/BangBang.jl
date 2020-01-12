module TestMerge

include("preamble.jl")
using BangBang.NoBang: SingletonDict

function signature(args)
    #! format: off
    strs = (
        if a isa Function
            string(a)
        elseif a isa NamedTuple
            "::NamedTuple"
        else
            "::$(typeof(a))"
        end for a in args
    )
    #! format: on
    return join(strs, ", ")
end

@testset "widen" begin
    @testset "merge!!($(signature(args)))" for (args, desired) in Any[
        ((Dict(:a => 1), Dict(:b => 0.5)), Dict(:a => 1.0, :b => 0.5)),
        ((Dict(:a => 1), Dict("b" => 2)), Dict(:a => 1, "b" => 2)),
        ((Dict(:a => 1), Dict("b" => 0.5)), Dict(:a => 1.0, "b" => 0.5)),
        (((a = 1,), (b = 2,)), (a = 1, b = 2)),
        (((a = 1,), Dict(:b => 2)), (a = 1, b = 2)),
        (((a = 1,), Dict(:b => 2), (b = 3,)), (a = 1, b = 3)),
        ((Empty(Dict), Dict(:a => 1)), Dict(:a => 1)),
        ((Empty(Dict), SingletonDict(:a => 1)), Dict(:a => 1)),
    ]
        d = deepcopy(args[1])
        @test merge!!(args...) ==ₜ desired
        @test args[1] == d
    end
    @testset "merge!!($(signature(args)))" for (args, desired) in Any[
        ((+, Dict(:a => 1), Dict(:a => 0.5)), Dict(:a => 1.5)),
        ((+, (a = 1,), Dict(:a => 0.5)), (a = 1.5,)),
    ]
        d = deepcopy(args[2])
        @test merge!!(args...) ==ₜ desired
        @test args[2] == d
    end
end

@testset "mutate" begin
    @testset "merge!!($(signature(args)))" for (args, desired) in Any[
        ((Dict(:a => 1), Dict(:b => 2)), Dict(:a => 1, :b => 2)),
        ((Dict(:a => 1), (b = 2,)), Dict(:a => 1, :b => 2)),
    ]
        @test merge!!(args...) === args[1] == desired
    end
    @testset "merge!!($(signature(args)))" for (args, desired) in Any[
        ((+, Dict(:a => 1), Dict(:a => 2)), Dict(:a => 3)),
        ((+, Dict(:a => 1), (a = 2,)), Dict(:a => 3)),
        ((+, Dict(:a => 1), (a = 2,), Dict(:a => 3)), Dict(:a => 6)),
    ]
        @test merge!!(args...) === args[2] == desired
    end
end

end  # module
