module TestInitialValues

include("preamble.jl")
using InitialValues: Init, hasinitialvalue

@testset begin
    @test hasinitialvalue(push!!)
    @test hasinitialvalue(append!!)
    @test push!!(Init(push!!), 1) == [1]
    @test append!!(Init(append!!), [1]) == [1]
    @test append!!([1], Init(append!!)) == [1]
end

end  # module
