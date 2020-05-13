module TestUnique

include("preamble.jl")

@testset begin
    @test unique!!([3, 2, 1, 2, 3]) == [3, 2, 1]
    @test unique!!(x for x in [3, 2, 1, 2, 3]) == [3, 2, 1]
end

@testset "mutation" begin
    @testset "Vector" begin
        x = [3, 2, 1, 2, 3]
        y = unique(x)
        @test unique!!(x) === x == y
    end
    @testset "Set" begin
        x = Set([0])
        @test unique!!(x) === x
    end
end

end  # module
