module BangBang

# Use README as the docstring of the module:
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) BangBang

export
    append!!,
    empty!!,
    mul!!,
    pop!!,
    popfirst!!,
    push!!,
    pushfirst!!,
    setproperty!!

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
    @require UniversalIdentity="b8f959e8-97da-11e9-3356-bb6559ac5c1b" begin
        include("universalidentity.jl")
    end
end

end # module
