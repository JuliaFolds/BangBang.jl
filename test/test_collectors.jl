module TestCollectors

include("preamble.jl")

@testset "stable eltype" begin
    @testset for unsafe in [false, true]
        n = 10
        @testset "$label" for (label, src) in [
            "vector" => 1:n,
            "generator" => (x + 1 for x in 1:n),
            "filter" => (x for x in 1:n if isodd(x)),
        ]
            data = Vector{Int}(undef, n)
            c = collector(data, Val(unsafe))
            @test finish!(append!!(c, src)) === data
            @test data == collect(src)
        end
    end
end

@testset "unstable eltype" begin
    @testset for unsafe in [false, true]
        n = 10
        @testset "$label" for (label, src) in [
            "generator" => (x > 5 ? nothing : x for x in 1:n),
            "filter" => (x > 5 ? nothing : x for x in 1:n if isodd(x)),
        ]
            data = Vector{Int}(undef, n)
            c = collector(data, Val(unsafe))
            result = finish!(append!!(c, src))
            @test result !== data
            @test result == collect(src)
            @test data[1] == 1
        end
    end
end

@testset "combine" begin
    c1 = append!!(collector(), [1, 2])
    c2 = append!!(collector(), [3, 4, 5])
    @test finish!(append!!(c1, c2)) == 1:5

    @test finish!(append!!(collector(), collector())) ==ₜ Union{}[]
end

@testset "Empty" begin
    @test finish!(append!!(collector(), Union{}[])) ==ₜ Union{}[]
    @test finish!(append!!(collector(), ())) ==ₜ Union{}[]
end

end  # module
