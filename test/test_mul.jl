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
    @test_inferred mul!!(C, A, B)

    C = zeros(Int, size(A * B))
    @test mul!!(C, A, B) :: Matrix{Float64} == A * B
    @test_inferred mul!!(C, A, B)
end

if VERSION >= v"1.3"
    @testset "mul!(C, A, B, α, β)" begin
        C = zeros(2, 2)
        A = reshape(1:4, 2, 2)
        B = ones(2, 2)

        desired = A * B * 3 + C * 4
        @test mul!!(C, A, B, 3, 4) === C
        @test C == desired
        @test_inferred mul!!(C, A, B, 3, 4)

        desired = A * B * 3 + C * 4
        @test mul!!(C, A, B, 3, 4) :: Matrix{Float64} == desired
        @test_inferred mul!!(C, A, B, 3, 4)
    end
end

end  # module
