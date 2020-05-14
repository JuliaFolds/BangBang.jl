module TestModify

include("preamble.jl")
using BangBang.Experimental: modify!!

function modify!(f, d, k)
    d′, v = modify!!(f, d, k)
    @test d′ === d
    return v
end

@testset "modify!(f, ::$constructor, key)" for constructor in [
    Dict,
    # SingletonDict,
]
    @testset "update" begin
        dict = constructor(Dict("a" => 1))

        @test modify!(dict, "a") do old
            Some(something(old, 0) + 1)
        end == Some(2)

        @test Dict(dict) == Dict("a" => 2)
    end

    @testset "insert" begin
        dict = constructor(Dict())

        @test modify!(dict, "a") do old
            Some(something(old, 0) + 1)
        end == Some(1)

        @test Dict(dict) == Dict("a" => 1)
    end

    @testset "delete" begin
        dict = constructor(Dict("a" => 1))
        @test modify!(_ -> nothing, dict, "a") === nothing
        @test Dict(dict) == Dict()
    end

    @testset "no-op" begin
        dict = constructor(Dict("a" => 1))
        @test modify!(_ -> nothing, dict, "b") === nothing
        @test Dict(dict) == Dict("a" => 1)

        dict = constructor(Dict("a" => 1))
        @test modify!(_ -> nothing, dict, :b) === nothing
        @test Dict(dict) == Dict("a" => 1)

        dict = constructor(Dict("a" => 1))
        @test modify!(identity, dict, "a") === Some(1)
        @test Dict(dict) == Dict("a" => 1)

        dict = constructor(Dict(:a => 1))
        @test modify!(identity, dict, :a) === Some(1)
        @test Dict(dict) == Dict(:a => 1)
    end

    @testset "mutation inside `f`" begin
        dict = constructor(Dict())

        @test modify!(dict, "a") do old
            dict["a"] = 0
            Some(something(old, 0) + 1)
        end == Some(1)

        @test Dict(dict) == Dict("a" => 1)
    end
end

@testset "modify!!(f, ::Dict, key)" begin
    @testset "update" begin
        dict = Dict("a" => 1)
        backup = deepcopy(dict)
        dict′, ret = modify!!(dict, "a") do old
            Some(something(old, 0) + 0.5)
        end
        @test ret === Some(1.5)
        @test dict′ == Dict("a" => 1.5)
        @test dict == backup
    end

    @testset "insert" begin
        dict = Dict{Union{},Union{}}()
        backup = deepcopy(dict)
        dict′, ret = modify!!(dict, "a") do old
            Some(something(old, 0) + 1)
        end
        @test ret == Some(1)
        @test dict′ == Dict("a" => 1)
        @test dict == backup
    end

    @testset "no-op" begin
        dict = Dict("a" => 1)
        backup = deepcopy(dict)
        dict′, ret = modify!!(_ -> nothing, dict, :b)
        @test ret === nothing
        @test dict′ === dict == backup
    end

    @testset "mutation inside `f` while widening value type" begin
        dict = Dict{String,Int}()
        dict′, ret = modify!!(dict, "a") do old
            dict["a"] = 0
            Some(something(old, 0) + 0.5)
        end
        @test ret === Some(0.5)
        @test dict′ == Dict("a" => 0.5)
        @test dict == Dict("a" => 0)
    end

    @testset "mutation inside `f` while widening key type" begin
        dict = Dict{String,Int}()
        dict′, ret = modify!!(dict, :b) do old
            dict["a"] = 0
            Some(something(old, 0) + 0.5)
        end
        @test ret === Some(0.5)
        @test dict′ == Dict("a" => 0, :b => 0.5)
        @test dict == Dict("a" => 0)
    end
end

@testset "modify!!(f, ::NamedTuple, key)" begin
    @testset "update" begin
        @test modify!!((a = 1,), :a) do old
            Some(something(old, 0) + 1)
        end === ((a = 2,), Some(2))
    end

    @testset "insert" begin
        @test modify!!(NamedTuple(), :a) do old
            Some(something(old, 0) + 1)
        end === ((a = 1,), Some(1))
    end

    @testset "delete" begin
        @test modify!!((a = 1,), :a) do old
            nothing
        end === (NamedTuple(), nothing)
    end

    @testset "no-op" begin
        @test modify!!((a = 1,), :b) do old
            nothing
        end === ((a = 1,), nothing)
    end
end

end  # module
