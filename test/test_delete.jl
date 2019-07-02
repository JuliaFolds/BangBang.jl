module TestDelete

include("preamble.jl")

@testset begin
    @test delete!!((a = 1,), :a) === NamedTuple()
    @test delete!!((a = 1,), :b) === (a = 1,)
    @test delete!!(Dict(:a => 1), :a) == Dict()
    @test delete!!(Dict(:a => 1), :b) == Dict(:a => 1)
end

end  # module
