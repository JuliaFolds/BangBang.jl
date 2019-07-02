module TestPop

include("preamble.jl")

@testset "pop(sequence)" begin
    @test pop!!([0, 1]) == ([0], 1)
    @test pop!!((0, 1)) === ((0,), 1)
    @test pop!!((a=0, b=1)) === ((a=0,), 1)
    @test_broken pop!!(SVector(0, 1)) === (SVector(0), 1)
end

@testset "pop(assoc, key)" begin
    @test pop!!(Dict(:a => 1), :a) == (Dict(), 1)
    @test pop!!((a=1,), :a) == (NamedTuple(), 1)
end

@testset "pop(assoc, key, default)" begin
    @test pop!!(Dict(:a => 1), :a, nothing) == (Dict(), 1)
    @test pop!!(Dict(:a => 1), :b, nothing) == (Dict(:a => 1), nothing)
    @test pop!!((a=1,), :a, nothing) == (NamedTuple(), 1)
    @test pop!!((a=1,), :b, nothing) == ((a=1,), nothing)
end

@testset "mutation" begin
    @testset for args in [
        ([0],),
        (Dict(:a => 1), :a),
        (Dict(:a => 1), :a, nothing),
        (Dict(:a => 1), :b, nothing),
    ]
        @test pop!!(args...)[1] === args[1]
    end
end

end  # module
