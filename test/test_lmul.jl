module TestLmul

include("preamble.jl")
using LinearAlgebra

@testset begin
    @test lmul!!(1, 2) === 2

    A = LowerTriangular(reshape(1:4, 2, 2))
    B = ones(2, 2)
    AB = A * B
    @test lmul!!(A, B) === B
    @test B == AB
end

end  # module
