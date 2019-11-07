module TestStructArrays

using Test
using BangBang
using StructArrays

@testset "push!!" begin
    xs = StructVector{ComplexF64}(([1.0, 2.0], [3.0, 4.0]))
    ys = push!!(xs, 5 + 6im)
    @test ys == [1 + 3im, 2 + 4im, 5 + 6im]
    @test_broken xs === ys
    xs = StructVector{Complex{Int}}(([1, 2], [3, 4]))
    ys = push!!(xs, 5.0 + 6.0im)
    @test ys == [1 + 3im, 2 + 4im, 5 + 6im]
    @test_broken eltype(ys) == ComplexF64
end

@testset "append!!" begin
    xs = StructVector{ComplexF64}(([1.0, 2.0], [3.0, 4.0]))
    ys = append!!(xs, [5 + 6im])
    @test ys == [1 + 3im, 2 + 4im, 5 + 6im]
    @test_broken xs === ys
    xs = StructVector{Complex{Int}}(([1, 2], [3, 4]))
    ys = append!!(xs, 5.0 + 6.0im)
    @test ys == [1 + 3im, 2 + 4im, 5 + 6im]
    @test_broken eltype(ys) == ComplexF64
end

@testset "type inference" begin
    @test (@inferred singletonof(StructVector, (a=1,))) == StructVector((a=[1]))
end

end  # module
