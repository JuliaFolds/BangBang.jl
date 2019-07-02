module TestSplice

include("preamble.jl")

@testset begin
    @test splice!!((1, 2, 3), 2) === ((1, 3), 2)
    @test splice!!([1, 2, 3], 2) == ([1, 3], 2)
    @test splice!!([1, 2, 3], 2, 20) == ([1, 20, 3], 2)
    @test splice!!((1, 2, 3), 2, 20) === ((1, 20, 3), 2)
    @test splice!!([1, 2, 3], 2:3) == ([1], [2, 3])
    @test splice!!([1, 2, 3], 2:3, [20, 30]) == ([1, 20, 30], [2, 3])
end

end  # module
