module TestPush

include("preamble.jl")
using BangBang.NoBang: push

@testset begin
    @test push!!([0.0], 1.0) == [0.0, 1.0]
    @test push!!([0], 1.0, 2im, UInt(3)) == [0.0, 1.0, 2im, 3]
    @test push!!([0], 1.0) == [0.0, 1.0]
    @test push!!((0,), 1) === (0, 1)
    @test push((0,), 1) === (0, 1)
    @test push!!((0,), 1.0, 2im, UInt(3)) === (0, 1.0, 2im, UInt(3))
    @test push((0,), 1.0, 2im, UInt(3)) === (0, 1.0, 2im, UInt(3))
    @test push!!((a=0,), :b => 1) === (a=0, b=1)
    @test push!!((a=0,), Val(:b) => 1) === (a=0, b=1)
    @test push!!(SVector(0), 1) === SVector(0, 1)
    @test push!!(ImmutableDict(:a=>1), :b=>2) ==
        ImmutableDict(ImmutableDict(:a=>1), :b=>2)
    @test push!!(Dict(), :a=>1)::Dict{Any,Any} == Dict(:a=>1)
    @test push!!(Dict{Union{},Union{}}(), :a=>1)::Dict{Symbol,Int} == Dict(:a=>1)
    @test push!!(Set(), 1)::Set{Any} == Set(1)
    @test push!!(Set{Union{}}(), 1)::Set{Int} == Set(1)
end

@testset "error" begin
    err = @test_error push!!((a=1,), :b)
    @test occursin("`push(::NamedTuple, x::Symbol)` is not supported",
                   sprint(showerror, err))
end

end  # module
