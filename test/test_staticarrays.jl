module TestStaticArrays

include("preamble.jl")
using BangBang: implements
using StaticArrays: MArray, MMatrix, MVector, SArray, SMatrix, SVector

@testset "implements(push!, _)" begin
    @test !implements(push!, SVector(0))
    @test !implements(push!, SMatrix{1, 1}(0))
    @test !implements(push!, MVector(0))
    @test !implements(push!, MMatrix{1, 1}(0))
end

@testset "implements(setindex!, _)" begin
    @test !implements(setindex!, SVector(0))
    @test !implements(setindex!, SMatrix{1, 1}(0))
    @test implements(setindex!, MVector(0))
    @test implements(setindex!, MMatrix{1, 1}(0))
end

@testset "push!!" begin
    @test push!!(SVector(1, 2, 3), 4) === SVector(1, 2, 3, 4)
    @test push!!(MVector(1, 2, 3), 4) ==ₜ MVector(1, 2, 3, 4)
end

@testset "setindex!!(SArray, ...)" begin
    @test setindex!!(SVector(1, 2, 3), 200, 2) === SVector(1, 200, 3)
    @test_broken setindex!!(SVector(1, 2, 3), 0.2, 2) === SVector(1.0, 0.2, 3.0)
end

@testset "setindex!!(MArray, ...)" begin
    xs = MVector(1, 2, 3)
    @test setindex!!(xs, 200, 2) === xs ==ₜ MVector(1, 200, 3)
    @test_broken setindex!!(xs, 0.2, 2) === xs ==ₜ MVector(1.0, 0.2, 3.0)
end

@testset "Empty" begin
    @test push!!(Empty(SVector), 1) === SVector(1)
    @test push!!(Empty(SArray), 1) === SVector(1)
    @test push!!(Empty(MVector), 1) ==ₜ MVector(1)
    @test push!!(Empty(MArray), 1) ==ₜ MVector(1)
end

end  # module
