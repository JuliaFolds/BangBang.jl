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
    @test_inferred lmul!!(A, B)

    A = LowerTriangular(collect(Float64, reshape(1:4, 2, 2)))
    B = ones(Int, 2, 2)
    AB = A * B
    @test lmul!!(A, B) :: Matrix{Float64} == AB
    @test_inferred lmul!!(A, B)
end

end  # module
