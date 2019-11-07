module TestSetfield

include("preamble.jl")
using Setfield: @lens, Lens, Setfield, set

struct LensWrapper <: Lens
    lens::Lens
end

Setfield.get(obj, lens::LensWrapper) = get(obj, lens.lens)
Setfield.set(obj, lens::LensWrapper, value) = set(obj, lens.lens, value)

mutable struct Mutable
    a
    b
end

@testset "nested mutable" begin
    x = orig = Mutable((x=Mutable(1, 2), y=3), 4);
    @set!! x.a.x.a = 10;
    @test x.a.x.a == orig.a.x.a == 10
end

@testset "arrays" begin
    v = [1, 2, Mutable(1, 2)]
    x = orig = Mutable((x=v, y=3), 4);
    @set!! x.a.x[3].a = 10;
    @test x.a.x[3].a == orig.a.x[3].a == 10
    @test x.a.x === v
end

@testset "index lenses" begin
    @testset "ConstIndexLens" begin
        v = [1, 2, 3]
        i = j = 1
        @set!! v[$(i + j)] = 20
        @test v[2] == 20
    end
    @testset "DynamicIndexLens" begin
        v = [1, 2, 3]
        @set!! v[end] = 30
        @test v[3] == 30
    end
end

@testset "default to immutable" begin
    x = Mutable((x=Mutable(1, 2), y=3), 4);
    l = prefermutation(LensWrapper(@lens _.a.x.a))
    y = set(x, l, 10)
    @test y !== x
    @test y.a.x.a == 10
end

end  # module
