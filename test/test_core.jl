module TestCore

include("preamble.jl")

@testset begin
    @test implements(push!, [])
    @test implements(push!, Dict(:a=>1))
    @test !implements(push!, ())
    @test !implements(push!, (a=1,))
    @test !implements(push!, SVector(0))
end

end  # module
