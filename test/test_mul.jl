module TestMul

include("preamble.jl")
using StaticArrays: SMatrix

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
    @test mul!!(C, A, B)::Matrix{Float64} == A * B
    @test_inferred mul!!(C, A, B)
end

if VERSION >= v"1.3"
    @testset "mul!(C, A, B, α, β)" begin
        @testset "$label" for (label, isinplace, C, A, B) in [
            (
             label = "C :: Matrix{Float64} (eltype compatible)",
             isinplace = true,
             C = zeros(2, 2),
             A = reshape(1:4, 2, 2),
             B = ones(2, 2),
            ),
            (
             label = "C :: Matrix{Int} (eltype compatible)",
             isinplace = true,
             C = zeros(Int, 2, 2),
             A = reshape(1:4, 2, 2),
             B = ones(Int, 2, 2),
            ),
            (
             label = "C :: Matrix{Int} (eltype incompatible)",
             isinplace = false,
             C = zeros(Int, 2, 2),
             A = reshape(1:4, 2, 2),
             B = ones(2, 2),
            ),
            (
             label = "C :: SMatrix",
             isinplace = false,
             C = SMatrix{2,2}(0, 0, 0, 0),
             A = SMatrix{2,2}(1, 2, 3, 4),
             B = SMatrix{2,2}(5, 6, 7, 8),
            ),
        ]
            desired = A * B * 3 + C * 4
            actual = mul!!(C, A, B, 3, 4)
            @test actual == desired
            if isinplace
                @test C === actual
            end
            @test_inferred mul!!(C, A, B, 3, 4)
        end
    end
end

end  # module
