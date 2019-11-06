module TestPushfirst

include("preamble.jl")

@testset begin
    @test pushfirst!!([0.0], 1.0) == [1.0, 0.0]
    @test pushfirst!!([0], 1.0) == [1.0, 0.0]
    @test pushfirst!!((0,), 1) === (1, 0)
    @test pushfirst!!(SVector(0), 1) == SVector(1, 0)
    @test pushfirst!!(SVector(0), 1) === SVector(1, 0)
end

end  # module
