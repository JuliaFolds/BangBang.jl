module TestPreamble

include("preamble.jl")

@testset "==ₜ" begin
    @test 1 ==ₜ 1
    @test !(1.0 ==ₜ 1)
end

end  # module
