module TestMaterialize

include("preamble.jl")
using BangBang: air

@testset begin
    @test materialize!!(nothing, air.([0, 1] .+ 2))::Vector{Int} == [2, 3]
    @test materialize!!([NaN, NaN], air.([0, 1] .+ 2))::Vector{Real} == [2, 3]
    @test materialize!!(nothing, air.((0, 1) .+ 2))::Tuple === (2, 3)
    @test materialize!!(nothing, air.(SVector(0, 1) .+ 2))::SVector === SVector(2, 3)
end

@testset "type-unstable materialize!!" begin
    unstabletrue = Ref{Any}(true)
    unstableone(unused) = unstabletrue[] ? unstabletrue[] : unused
    @test materialize!!(nothing, air.([1] .+ unstableone.([0]) ./ [1])) == [2]
end

end  # module
