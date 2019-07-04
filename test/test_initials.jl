module TestInitials

include("preamble.jl")
using Initials: Init, hasinitial

@testset begin
    @test hasinitial(push!!)
    @test hasinitial(append!!)
    @test push!!(Init(push!!), 1) == [1]
    @test append!!(Init(append!!), [1]) == [1]
end

end  # module
