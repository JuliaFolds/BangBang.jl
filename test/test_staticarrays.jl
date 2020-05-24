module TestStaticArrays

include("preamble.jl")
using BangBang: implements
using InitialValues: Init
using StaticArrays:
    MArray, MMatrix, MVector, SArray, SMatrix, SVector, StaticArrays, StaticVector

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
    if versionof(StaticArrays) >= v"0.12"  # not sure when it was fixed
        @test push!!(MVector(1, 2, 3), 4) ==ₜ MVector(1, 2, 3, 4)
    else
        # For StaticArrays 0.8
        @test_broken push!!(MVector(1, 2, 3), 4) ==ₜ MVector(1, 2, 3, 4)
        @test push!!(MVector(1, 2, 3), 4)::StaticVector == [1, 2, 3, 4]
    end
end

@testset "append!! with Init(append!!)" begin
    @test append!!(Init(append!!), SVector(1, 2)) === SVector(1, 2)
    @test append!!(SVector(1, 2), Init(append!!)) === SVector(1, 2)
    @test append!!(Init(append!!), MVector(1, 2)) ==ₜ MVector(1, 2)
    xs = MVector(1, 2)
    @test append!!(xs, Init(append!!)) === xs
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

@testset "empty!!" begin
    @test empty!!(SVector(1)) === SVector{0,Int}()
    @test isempty(empty!!(MVector(1)))
    if versionof(StaticArrays) >= v"0.12"  # not sure when it was fixed
        @test empty!!(MVector(1)) ==ₜ MVector{0,Int}()
    else
        # For StaticArrays 0.8
        @test_broken empty!!(MVector(1)) ==ₜ MVector{0,Int}()
    end
end

@testset "Empty" begin
    @test push!!(Empty(SVector), 1) === SVector(1)
    @test push!!(Empty(SArray), 1) === SVector(1)
    @test push!!(Empty(MVector), 1) ==ₜ MVector(1)
    @test push!!(Empty(MArray), 1) ==ₜ MVector(1)
end

end  # module
