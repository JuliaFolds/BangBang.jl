module TestDoctest

import BangBang
using Documenter: doctest
using Test

@testset "doctest" begin
    if lowercase(get(ENV, "JULIA_PKGEVAL", "false")) == "true"
        @info "Skipping doctests on PkgEval."
    elseif VERSION >= v"1.5-"
        @info "Skipping doctests on Julia $VERSION."
    else
        doctest(BangBang; manual = true)
    end
end

end  # module
