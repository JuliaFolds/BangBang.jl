module TestStaticArrays

include("preamble.jl")
using BangBang: ismutable
using StaticArrays: MArray, MMatrix, MVector, SArray, SMatrix, SVector

@testset begin
    @test !ismutable(SVector(0))
    @test !ismutable(SMatrix{1, 1}(0))
    @test ismutable(MVector(0))
    @test ismutable(MMatrix{1, 1}(0))
end

@testset "Empty" begin
    @test push!!(Empty(SVector), 1) === SVector(1)
    @test push!!(Empty(SArray), 1) === SVector(1)
    @test push!!(Empty(MVector), 1) ==ₜ MVector(1)
    @test push!!(Empty(MArray), 1) ==ₜ MVector(1)
end

end  # module
