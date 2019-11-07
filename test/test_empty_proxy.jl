module TestEmptyProxy

include("preamble.jl")

@testset begin
    @test collect(Empty(Vector)) == Union{}[]
    @test collect(Empty(Dict)) == Union{}[]
    @test collect(Empty(Set)) == Union{}[]
end

end  # module
