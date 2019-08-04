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

using InitialValues
using LinearAlgebra
using Requires

include("NoBang/NoBang.jl")
using .NoBang: ImmutableContainer

include("core.jl")
include("base.jl")
include("linearalgebra.jl")
include("initials.jl")

function __init__()
    @require StaticArrays="90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
end

end # module
