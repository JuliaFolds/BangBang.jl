module TestCore

include("preamble.jl")

@testset begin
    @test ismutable([])
    @test ismutable(Dict(:a=>1))
    @test !ismutable(())
    @test !ismutable((a=1,))
    @test !ismutable(SVector(0))
end

end  # module
