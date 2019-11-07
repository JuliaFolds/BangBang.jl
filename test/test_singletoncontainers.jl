module TestSingletonContainers

using BangBang.NoBang: SingletonDict, SingletonVector
using Tables: Tables
using Test

function test_shows(x)
    # smoke tests
    @test sprint(show, x) isa String
    @test sprint(show, "text/plain", x) isa String
    @test string(x) isa String
end

@testset "SingletonVector" begin
    v = SingletonVector(1)
    @test v[1] == 1
    @test_throws BoundsError v[2]
    @test size(v) == (1,)
    @test collect(v)::Vector{Int} == [1]
    test_shows(v)
end

@testset "SingletonVector as a table" begin
    @testset for T in [
        SingletonVector,
        SingletonVector{Int},
        SingletonVector{<:NamedTuple},
        SingletonVector{NamedTuple},
    ]
        @test !Tables.istable(T)
    end

    @testset for T in [
        SingletonVector{<:NamedTuple{(:a,)}},
        SingletonVector{<:NamedTuple{(:a,),Tuple{Int}}},
    ]
        @test Tables.istable(T)
        @test Tables.rowaccess(T)
        @test Tables.columnaccess(T)
    end

    @testset begin
        @test Tables.rows(SingletonVector((a = 1,))) == [(a = 1,)]
        @test Tables.columns(SingletonVector((a = 1,))) == (a = [1],)
    end
end

@testset "SingletonDict" begin
    d = SingletonDict(:a, 1)
    @test d[:a] == 1
    @test_throws BoundsError d[:non_existing_key]
    @test collect(d)::Vector{Pair{Symbol,Int}} == [:a => 1]
    test_shows(d)
end

end  # module
