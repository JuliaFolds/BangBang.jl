module TestPopfirst

include("preamble.jl")

@testset begin
    @test popfirst!!([0, 1]) == ([1], 0)
    @test popfirst!!((0, 1)) === ((1,), 0)
    @test popfirst!!((a=0, b=1)) === ((b=1,), 0)
    @test_broken popfirst!!(SVector(0, 1)) === (SVector(0), 1)
end

@testset "mutation" begin
    @testset for xs in [
        [0, 1],
    ]
        @test popfirst!!(xs)[1] === xs
    end
end

end  # module
