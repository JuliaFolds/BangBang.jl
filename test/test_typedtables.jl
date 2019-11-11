module TestTypedTables

using BangBang: append!!, push!!, singletonof
using Tables: Tables
using Test
using TypedTables: Table

@testset "push!!" begin
    tints = Table(a = [1], b = [2])
    @test push!!(tints, (a = 3.0, b = 4.0))::Table == Table(a = [1.0, 3.0], b = [2.0, 4.0])
    @test tints == Table(a = [1], b = [2])

    tints = Table(a = [1], b = [2])
    @test push!!(tints, (a = 3, b = 4)) === tints
    @test tints == Table(a = [1, 3], b = [2, 4])

    @test push!!(Table(a = [1]), Tables.IteratorRow((a = 2,))) == Table(a = [1, 2])
end

@testset "append!!" begin
    tints = Table(a = [1], b = [2])
    @test append!!(tints, [(a = 3.0, b = 4.0)])::Table == Table(
        a = [1.0, 3.0],
        b = [2.0, 4.0],
    )
    @test tints == Table(a = [1], b = [2])

    tints = Table(a = [1], b = [2])
    @test_broken append!!(tints, [(a = 3, b = 4)]) === tints
    @test_broken tints == Table(a = [1, 3], b = [2, 4])
end

@testset "type inference" begin
    @test (@inferred singletonof(Table, (a=1,))) == Table((a=[1]))
end

end  # module
