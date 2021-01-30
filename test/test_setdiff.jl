module TestSetdiff

include("preamble.jl")
# using MicroCollections: SingletonSet

@testset begin
    @test_returns_first setdiff!!([0], [0]) == []
    @test_returns_first setdiff!!([0], (0,)) == []
    @test_returns_first setdiff!!([0, 1, 2], (0,), [1]) == [2]
    @test_returns_first setdiff!!(Set([0]), [0]) == Set()
    @test_returns_first setdiff!!(Set([0]), (0,)) == Set()
    @test_returns_first setdiff!!(Set([0, 1, 2]), Set([0]), [1]) == Set([2])
    @test setdiff!!(Empty(Vector), []) === Empty(Vector)
    @test setdiff!!(Empty(Set{Int}), []) === Empty(Set{Int})
    #=
    @test setdiff!!(SingletonSet((0,)), [0]) ==ₜ Set{Int}()
    @test setdiff!!(SingletonSet((0,)), [1]) ==ₜ Set([0])
    =#
end

end  # module
