module BangBang

# Use README as the docstring of the module:
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) BangBang

export @!,
       @set!!,
       Empty,
       append!!,
       delete!!,
       deleteat!!,
       empty!!,
       lmul!!,
       materialize!!,
       mul!!,
       pop!!,
       popfirst!!,
       prefermutation,
       push!!,
       pushfirst!!,
       rmul!!,
       setindex!!,
       setproperties!!,
       setproperty!!,
       singletonof,
       splice!!

using ArrayInterface: ArrayInterface
using Base.Broadcast: materialize!
using Compat: hasproperty
using InitialValues
using LinearAlgebra
using Requires
using Tables: Tables
using ZygoteRules: @adjoint

# Used in NoBang:
function ismutable end
function push!! end

include("NoBang/NoBang.jl")
using .NoBang: Empty, ImmutableContainer, singletonof

include("core.jl")
include("base.jl")
include("linearalgebra.jl")
include("initials.jl")
include("macro.jl")
include("dataframes_impl.jl")
include("zygote.jl")

include("setfield.jl")
using .SetfieldImpl: @set!!, prefermutation

function __init__()
    @require StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a" begin
        include("structarrays.jl")
    end
    @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        include("dataframes.jl")
    end
end

end # module
