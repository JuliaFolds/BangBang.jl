module TestEmpty

include("preamble.jl")

@testset begin
    @test empty!!((1, 2, 3)) === ()
    @test empty!!((a=1, b=2, c=3)) === NamedTuple()
    @test empty!!([1, 2, 3]) == []
end

@testset "mutation" begin
    @testset for xs in [
        [0, 1],
    ]
        @test empty!!(xs) === xs
    end
end

end  # module
