module TestEmptyProxy

include("preamble.jl")

==ₜₗ(_, _) = false
==ₜₗ(x::T, y::T) where {T} = length(x) == length(y)

@testset begin
    @test collect(Empty(Vector)) == Union{}[]
    @test collect(Empty(Dict)) == Union{}[]
    @test collect(Empty(Set)) == Union{}[]
end

@testset "similar" begin
    @test similar(Empty(Vector)) ==ₜ Union{}[]
    @test similar(Empty(Vector{Union{}})) ==ₜ Union{}[]
    @test similar(Empty(Vector{Int})) ==ₜ Int[]
    @test similar(Empty(Vector), Int) ==ₜ Int[]
    @test similar(Empty(Vector{Union{}}), Int) ==ₜ Int[]
    @test similar(Empty(Vector{Int}), Symbol) ==ₜ Symbol[]

    @test similar(Empty(Vector), 3) ==ₜₗ resize!(Union{}[], 3)
    @test similar(Empty(Vector{Union{}}), 3) ==ₜₗ resize!(Union{}[], 3)
    @test similar(Empty(Vector{Int}), 3) ==ₜₗ resize!(Int[], 3)
    @test similar(Empty(Vector), Int, 3) ==ₜₗ resize!(Int[], 3)
    @test similar(Empty(Vector{Union{}}), Int, 3) ==ₜₗ resize!(Int[], 3)
    @test similar(Empty(Vector{Int}), Symbol, 3) ==ₜₗ resize!(Symbol[], 3)

    @test similar(Empty(Vector), (3,)) ==ₜₗ resize!(Union{}[], 3)
    @test similar(Empty(Vector{Union{}}), (3,)) ==ₜₗ resize!(Union{}[], 3)
    @test similar(Empty(Vector{Int}), (3,)) ==ₜₗ resize!(Int[], 3)
    @test similar(Empty(Vector), Int, (3,)) ==ₜₗ resize!(Int[], 3)
    @test similar(Empty(Vector{Union{}}), Int, (3,)) ==ₜₗ resize!(Int[], 3)
    @test similar(Empty(Vector{Int}), Symbol, (3,)) ==ₜₗ resize!(Symbol[], 3)
end

end  # module
