module TestTypedTables

using Test
using BangBang
using TypedTables

@testset "push!!" begin
    tints = Table(a = [1], b = [2])
    @test push!!(tints, (a = 3.0, b = 4.0))::Table == Table(a = [1.0, 3.0], b = [2.0, 4.0])
    @test tints == Table(a = [1], b = [2])

    tints = Table(a = [1], b = [2])
    @test push!!(tints, (a = 3, b = 4)) === tints
    @test tints == Table(a = [1, 3], b = [2, 4])
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

end  # module
