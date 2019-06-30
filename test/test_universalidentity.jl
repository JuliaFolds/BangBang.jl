module TestUniversalidentity

include("preamble.jl")
using UniversalIdentity: Identity, hasidentity

@testset begin
    @test hasidentity(push!!)
    @test hasidentity(append!!)
    @test push!!(Identity(push!!), 1) == [1]
    @test append!!(Identity(append!!), [1]) == [1]
end

end  # module
