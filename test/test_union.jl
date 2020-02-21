module TestUnion

include("preamble.jl")

@testset begin
    @test union!!([0.0], [1.0]) ==ₜ [0.0, 1.0]
    @test union!!([0], [0.5]) ==ₜ [0.0, 0.5]
    @test union!!(Set([0.0]), [1.0]) ==ₜ Set([0.0, 1.0])
    @test union!!(Set([0]), [0.5]) ==ₜ Set([0.0, 0.5])
end

@testset "mutation" begin
    @testset "Vector" begin
        x = [0.0]
        @test union!!(x, [1]) === x
        @test x ==ₜ [0.0, 1.0]
    end
    @testset "Set" begin
        x = Set([0.0])
        @test union!!(x, [1]) === x
        @test x ==ₜ Set([0.0, 1.0])
    end
end

end  # module
