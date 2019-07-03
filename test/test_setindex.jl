module TestSetIndex

include("preamble.jl")

@testset begin
    @test setindex!!((1, 2, 3), :two, 2) === (1, :two, 3)
    @test setindex!!((a=1, b=2, c=3), :two, :b) === (a=1, b=:two, c=3)
    @test setindex!!([1, 2, 3], :two, 2) == [1, :two, 3]
    @test setindex!!(Dict{Symbol,Int}(:a=>1, :b=>2), 10, :a) ==
        Dict(:a=>10, :b=>2)
    @test setindex!!(Dict{Symbol,Int}(:a=>1, :b=>2), 3, "c") ==
        Dict(:a=>1, :b=>2, "c"=>3)
end

@testset "mutation" begin
    @testset for args in [
        ([1, 2, 3], 20, 2),
        (Dict(:a=>1, :b=>2), 10, :a),
    ]
        @test setindex!!(args...) === args[1]
    end
end

end  # module
