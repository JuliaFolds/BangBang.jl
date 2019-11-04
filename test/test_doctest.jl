module TestDoctest

import BangBang
using Documenter: doctest
using Test

@testset "doctest" begin
    doctest(BangBang; manual = true)
end

end  # module
