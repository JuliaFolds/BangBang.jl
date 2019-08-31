module TestMul

include("preamble.jl")

@testset begin
    @test mul!!(0, 1, 2) === 2
    @test mul!!(missing, 1, 2) === 2
    @test mul!!(nothing, 1, 2) === 2

    C = zeros(2, 2)
    A = reshape(1:4, 2, 2)
    B = ones(2, 2)
    @test mul!!(C, A, B) === C
    @test C == A * B

    C = zeros(Int, size(A * B))
    @test mul!!(C, A, B) :: Matrix{Float64} == A * B
end

end  # module
