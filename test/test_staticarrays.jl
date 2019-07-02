module TestStaticArrays

using Test
using BangBang: ismutable
using StaticArrays

@testset begin
    @test !ismutable(SVector(0))
    @test !ismutable(SMatrix{1, 1}(0))
    @test ismutable(MVector(0))
    @test ismutable(MMatrix{1, 1}(0))
end

end  # module
