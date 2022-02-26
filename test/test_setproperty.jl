module TestSetProperty

include("preamble.jl")

struct ImmutableStruct
    a
    b
end

mutable struct MutableStruct
    a
    b
end

@testset begin
    @test setproperty!!((a=1, b=nothing), :b, 2) === (a=1, b=2)
    @test setproperty!!(ImmutableStruct(1, nothing), :b, 2) ==
        ImmutableStruct(1, 2)
    ms = MutableStruct(1, nothing)
    @test setproperty!!(ms, :b, 2) === ms
    @test ms.b == 2
end

@testset "inference" begin
    nt = (a = 1, b = 2)
    f!!(nt) = setproperty!!(nt, :a, 3)
    @test @inferred(f!!(nt)) == (a = 3, b = 2)
end

end  # module
