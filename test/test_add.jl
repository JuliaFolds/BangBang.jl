module TestAdd

include("preamble.jl")
using Base.Broadcast: broadcasted

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

@testset "broadcasted" begin
    @test @inferred(add!!(broadcasted(*, [1], [2]), [2])) ==ₜ [4]
    @test @inferred(add!!([1], broadcasted(/, [1], [2]))) ==ₜ [1.5]

    x = [1]
    @test @inferred(add!!(x, broadcasted(*, [1], [2]))) === x ==ₜ [3]
end

end  # module
