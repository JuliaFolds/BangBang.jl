module TestAppend

include("preamble.jl")

using BangBang.NoBang: SingletonVector
using StructArrays: StructVector

@testset begin
    @test append!!([0.0], [1.0]) == [0.0, 1.0]
    @test append!!([0], [1.0]) == [0.0, 1.0]
    @test append!!([0], (1.0,)) == [0.0, 1.0]
    @test append!!((0,), (1,)) === (0, 1)
    @test append!!((a=0,), pairs((b=1,))) === (a=0, b=1)
    @test append!!(ImmutableDict(:a=>1), ImmutableDict(:b=>2)) ==
        ImmutableDict(ImmutableDict(:a=>1), :b=>2)
    @test append!!("a", "b") === "ab"
    @test append!!(SVector(0), [1])::Vector == [0, 1]
    @test append!!([0], SVector(1))::Vector == [0, 1]
    @test append!!(Union{}[], Iterators.take(1:10, 3)) ==ₜ [1, 2, 3]
end

@testset "Empty" begin
    @testset "`append!!` must create a new collection" begin
        xs = [1]
        @test append!!(Empty(Vector), xs) !== xs
        @test append!!(Empty(Vector), xs) == xs
    end
    @testset "append!!(::Empty, ::Empty) :: Empty" begin
        @test append!!(Empty(Vector), Empty(Vector)) === Empty(Vector)
        @test append!!(Empty(Vector), Empty(Dict)) === Empty(Vector)
        @test append!!(Empty(Dict), Empty(Vector)) === Empty(Dict)
    end
    @testset "append!!(x, ::Empty) == x" begin
        x = [0]
        @test append!!(x, Empty(Vector)) === x == [0]
    end
    @testset "`mapreduce`" begin
        @test mapreduce(
            SingletonVector,
            append!!,
            Any[1, 2, 3];
            init = Empty(Vector),
        ) ==ₜ [1, 2, 3]

        @test mapreduce(
            x -> SingletonVector((a = x, b = x^2)),
            append!!,
            [1, 2, 3];
            init = Empty(StructVector),
        ) ==ₜ StructVector(a = [1, 2, 3], b = [1, 2, 3] .^ 2)
    end
end

end  # module
