module TestMaterialize

include("preamble.jl")
using BangBang: air

@testset begin
    @test materialize!!(nothing, air.([0, 1] .+ 2))::Vector{Int} == [2, 3]
    @test materialize!!([NaN, NaN], air.([0, 1] .+ 2))::Vector{Float64} == [2, 3]
    @test materialize!!(nothing, air.((0, 1) .+ 2))::Tuple === (2, 3)
    @test materialize!!(nothing, air.(SVector(0, 1) .+ 2))::SVector === SVector(2, 3)
end

end  # module
