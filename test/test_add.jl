module TestAdd

include("preamble.jl")

@testset begin
    @test add!!(1, 2) === 3
    @test add!!((1,), (2,)) === (3,)
    @test add!!([1], [2]) ==ₜ [3]
    @test add!!(SVector(1), SVector(2)) === SVector(3)
    @test add!!(SVector(1), [2]) == [3]  # ok if `SVector(3)`
    @test add!!([1], SVector(2)) ==ₜ [3]
    @test add!!([1], [0.5]) ==ₜ [1.5]
end

@testset "mutation" begin
    x = [1]
    @test add!!(x, [2]) === x ==ₜ [3]
end

end  # module
