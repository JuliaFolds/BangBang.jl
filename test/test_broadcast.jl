module TestBroadcast

using BangBang
using BangBang.Extras
using Test

@testset "broadcast!!" begin
    @testset "mutate" begin
        xs = fill(1234, 3)
        @test broadcast!!(+, xs, zeros(Int, 3), 1) === xs == ones(Int, 3)
    end

    @testset "widen" begin
        xs = fill(123, 3)
        @test broadcast!!(+, xs, [1, 2, 3], 0.5) == [1.5, 2.5, 3.5]
        @test all(==(123), xs)
    end
end

@testset "broadcast_inplace!!" begin
    @testset "mutate" begin
        xs = zeros(Int, 3)
        @test broadcast_inplace!!(+, xs, 1) === xs == ones(Int, 3)
    end

    @testset "widen" begin
        xs = ones(Int, 3)
        @test broadcast_inplace!!(+, xs, [1, 2, 3], 0.5) == [2.5, 3.5, 4.5]
        @test all(==(1), xs)
    end
end

end  # module
