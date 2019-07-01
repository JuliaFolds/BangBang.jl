module TestSetIndex

include("preamble.jl")

@testset begin
    @test setindex!!((1, 2, 3), :two, 2) === (1, :two, 3)
    @test setindex!!((a=1, b=2, c=3), :two, :b) === (a=1, b=:two, c=3)
    @test setindex!!([1, 2, 3], :two, 2) == [1, :two, 3]
end

@testset "mutation" begin
    @testset for args in [
        ([1, 2, 3], 20, 2),
    ]
        @test setindex!!(args...) === args[1]
    end
end

end  # module
