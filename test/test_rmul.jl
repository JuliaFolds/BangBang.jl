module TestRmul

include("preamble.jl")
using LinearAlgebra

@testset begin
    @test rmul!!(1, 2) === 2

    A = copy(reshape(1:4, 2, 2))
    B = UpperTriangular(ones(2, 2))
    AB = A * B
    @test rmul!!(A, B) === A
    @test A == AB
end

end  # module
