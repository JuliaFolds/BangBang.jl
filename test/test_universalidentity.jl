module TestUniversalidentity

include("preamble.jl")
using UniversalIdentity: Id, hasidentity

@testset begin
    @test hasidentity(push!!)
    @test hasidentity(append!!)
    @test push!!(Id(push!!), 1) == [1]
    @test append!!(Id(append!!), [1]) == [1]
end

end  # module
