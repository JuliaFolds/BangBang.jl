module TestBangBang
using Test

@testset "$file" for file in sort([file for file in readdir(@__DIR__) if match(
    r"^test_.*\.jl$",
    file,
) !== nothing])

    if file == "test_doctest.jl"
        if lowercase(get(ENV, "JULIA_PKGEVAL", "false")) == "true"
            @info "Skipping doctests on PkgEval."
            continue
        elseif !(v"1.4" <= VERSION < v"1.5-")
            @info "Skipping doctests on Julia $VERSION."
            continue
        end
    end

    if VERSION < v"1.2-" && file == "test_zygote.jl"
        @info "Skip $file for Julia $VERSION to avoid segfault"
        # For example:
        # https://travis-ci.com/JuliaFolds/BangBang.jl/builds/134791701
        # https://travis-ci.com/JuliaFolds/BangBang.jl/builds/134795161
        continue
    end

    include(file)
end

end  # module
