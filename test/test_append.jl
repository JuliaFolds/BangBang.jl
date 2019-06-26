module TestAppend

include("preamble.jl")

@testset begin
    @test append!!([0.0], [1.0]) == [0.0, 1.0]
    @test append!!([0], [1.0]) == [0.0, 1.0]
    @test append!!((0,), (1,)) === (0, 1)
    @test append!!((a=0,), pairs((b=1,))) === (a=0, b=1)
end

end  # module
