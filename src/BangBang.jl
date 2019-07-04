module BangBang

# Use README as the docstring of the module:
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) BangBang

export
    append!!,
    delete!!,
    empty!!,
    mul!!,
    pop!!,
    popfirst!!,
    push!!,
    pushfirst!!,
    setindex!!,
    setproperty!!,
    splice!!

using LinearAlgebra
using Requires

include("NoBang/NoBang.jl")
using .NoBang: ImmutableContainer

include("core.jl")
include("base.jl")
include("linearalgebra.jl")

function __init__()
    @require StaticArrays="90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
    @require Initials="f5763212-9e0f-11e9-37f1-074a78aac78e" begin
        include("initials.jl")
    end
end

end # module
