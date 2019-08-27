module TestMacro

include("preamble.jl")

@testset begin
    @test (@! push!(empty!([0, 1]), 2, 3)) == [2, 3]
    @test (@! push!(empty!((0, 1)), 2, 3)) == (2, 3)
end

end  # module
