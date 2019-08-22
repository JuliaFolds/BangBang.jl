module TestAppend

include("preamble.jl")

@testset begin
    @test append!!([0.0], [1.0]) == [0.0, 1.0]
    @test append!!([0], [1.0]) == [0.0, 1.0]
    @test append!!([0], (1.0,)) == [0.0, 1.0]
    @test append!!((0,), (1,)) === (0, 1)
    @test append!!((a=0,), pairs((b=1,))) === (a=0, b=1)
    @test append!!(ImmutableDict(:a=>1), ImmutableDict(:b=>2)) ==
        ImmutableDict(ImmutableDict(:a=>1), :b=>2)
    @test append!!("a", "b") === "ab"
    @test append!!(SVector(0), [1])::Vector == [0, 1]
    @test append!!([0], SVector(1))::Vector == [0, 1]
end

end  # module
