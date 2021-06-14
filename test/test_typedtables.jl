module TestTypedTables

include("preamble.jl")
using BangBang
using BangBang: SingletonVector
using ConstructionBase: constructorof
using Test
using TypedTables

@testset "push!!" begin
    tints = Table(a = [1], b = [2])
    @test push!!(tints, (a = 3.0, b = 4.0))::Table == Table(a = [1.0, 3.0], b = [2.0, 4.0])
    @test tints == Table(a = [1], b = [2])

    tints = Table(a = [1], b = [2])
    @test push!!(tints, (a = 3, b = 4)) === tints
    @test tints == Table(a = [1, 3], b = [2, 4])
end

@testset "append!!(::Table, ::$(constructorof(typeof(src)))) [widen]" for src in Any[
    [(a = 3.0, b = 4.0)],
    SingletonVector((a = 3.0, b = 4.0)),
]
    tints = Table(a = [1], b = [2])
    @test append!!(tints, src)::Table == Table(
        a = [1.0, 3.0],
        b = [2.0, 4.0],
    )
    @test tints == Table(a = [1], b = [2])
end

@testset "append!!(::Table, ::$(constructorof(typeof(src)))) [mutation]" for src in Any[
    # Broken:
    # [(a = 3, b = 4)],
    SingletonVector((a = 3, b = 4)),
]
    tints = Table(a = [1], b = [2])
    @test append!!(tints, src) === tints == Table(
        a = [1, 3],
        b = [2, 4],
    )
end

@testset "append!!" begin
    if versionof(TypedTables) >= v"1.2.4" && VERSION >= v"1.4" # could be older
        tints = Table(a = [1], b = [2])
        @test append!!(tints, [(a = 3, b = 4)]) === tints
        @test tints == Table(a = [1, 3], b = [2, 4])
    end
end

@testset "type inference" begin
    @test (@inferred singletonof(Table, (a=1,))) == Table((a=[1]))
end

end  # module
