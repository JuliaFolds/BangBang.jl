module TestRmul

include("preamble.jl")
using LinearAlgebra

@testset begin
    @test rmul!!(1, 2) === 2

    A = collect(Float64, reshape(1:4, 2, 2))
    B = UpperTriangular(ones(2, 2))
    AB = A * B
    @test rmul!!(A, B) === A
    @test A == AB
    @test_inferred rmul!!(A, B)

    A = collect(Int, reshape(1:4, 2, 2))
    B = UpperTriangular(ones(2, 2))
    AB = A * B
    @test rmul!!(A, B) :: Matrix{Float64} == AB
    @test_inferred rmul!!(A, B)
end

end  # module
