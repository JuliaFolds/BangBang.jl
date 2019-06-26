module TestPush

include("preamble.jl")

@testset begin
    @test push!!([0.0], 1.0) == [0.0, 1.0]
    @test push!!([0], 1.0) == [0.0, 1.0]
    @test push!!((0,), 1) === (0, 1)
    @test push!!((a=0,), :b => 1) === (a=0, b=1)
    @test push!!((a=0,), Val(:b) => 1) === (a=0, b=1)
end

end  # module
