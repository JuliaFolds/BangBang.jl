module BangBang

# Use README as the docstring of the module:
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) BangBang

export
    @!,
    append!!,
    delete!!,
    empty!!,
    lmul!!,
    materialize!!,
    mul!!,
    pop!!,
    popfirst!!,
    push!!,
    pushfirst!!,
    rmul!!,
    setindex!!,
    setproperty!!,
    splice!!

using Base.Broadcast: materialize!
using InitialValues
using LinearAlgebra
using Requires
using ZygoteRules: @adjoint

include("NoBang/NoBang.jl")
using .NoBang: ImmutableContainer

include("core.jl")
include("base.jl")
include("linearalgebra.jl")
include("initials.jl")
include("macro.jl")
include("zygote.jl")

function __init__()
    @require StaticArrays="90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
    @require StructArrays="09ab397b-f2b6-538f-b94a-2f83cf4a842a" begin
        include("structarrays.jl")
    end
end

end # module
