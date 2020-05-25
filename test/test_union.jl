module TestUnion

include("preamble.jl")
using BangBang: SingletonVector
using InitialValues: Init, asmonoid

@testset begin
    @test union!!([0.0], [1.0]) ==ₜ [0.0, 1.0]
    @test union!!([0], [0.5]) ==ₜ [0.0, 0.5]
    @test union!!(Set([0.0]), [1.0]) ==ₜ Set([0.0, 1.0])
    @test union!!(Set([0]), [0.5]) ==ₜ Set([0.0, 0.5])
    @test union!!(Empty(Set), [0]) ==ₜ Set([0])
    @test union!!(Empty(Set), SingletonVector(0)) ==ₜ Set([0])
end

@testset "Empty" begin
    @testset "union!!(::Empty, ::Empty) :: Empty" begin
        @test union!!(Empty(Set), Empty(Set)) === Empty(Set)
        @test union!!(Empty(Set), Empty(Vector)) === Empty(Set)
    end
end

@testset "mutation" begin
    @testset "Vector" begin
        x = [0.0]
        @test union!!(x, [1]) === x
        @test x ==ₜ [0.0, 1.0]
    end
    @testset "Set" begin
        x = Set([0.0])
        @test union!!(x, [1]) === x
        @test x ==ₜ Set([0.0, 1.0])
    end
end

@testset "Init" begin
    xs = Set([0])
    @test union!!(xs, Init(union!!)) === xs
    @test union!!(Init(union!!), xs) !== xs
    @test union!!(Init(union!!), xs) ==ₜ xs
    @test union!!(Init(union!!), (x for x in xs if true)) ==ₜ xs
    @test union!!(Init(union!!), Init(union!!)) === Init(union!!)
    @test asmonoid(union!!) === union!!
end

end  # module
