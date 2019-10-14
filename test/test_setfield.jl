module TestSetfield

include("preamble.jl")

mutable struct Mutable
    a
    b
end

@testset begin
    x = orig = Mutable((x=Mutable(1, 2), y=3), 4);
    @set!! x.a.x.a = 10;
    @test x.a.x.a == orig.a.x.a == 10
end

end  # module
