module BangBang

# Use README as the docstring of the module:
@doc read(joinpath(dirname(@__DIR__), "README.md"), String) BangBang

export @!,
       @set!!,
       Empty,
       add!!,
       append!!,
       broadcast!!,
       collector,
       delete!!,
       deleteat!!,
       empty!!,
       finish!,
       lmul!!,
       materialize!!,
       merge!!,
       mergewith!!,
       mul!!,
       pop!!,
       popfirst!!,
       prefermutation,
       push!!,
       pushfirst!!,
       rmul!!,
       setdiff!!,
       setindex!!,
       setproperties!!,
       setproperty!!,
       singletonof,
       splice!!,
       union!!,
       unique!!

using Base.Broadcast:
    Broadcasted,
    broadcasted,
    combine_eltypes,
    copyto_nonleaf!,
    instantiate,
    materialize!,
    preprocess
using Base: HasEltype, IteratorEltype, promote_typejoin
using Compat: hasproperty
using ConstructionBase: constructorof
using InitialValues
using LinearAlgebra
using Requires
using Tables: Tables
using ChainRulesCore: ChainRulesCore

include("utils.jl")

# Used in NoBang:
function implements end
function push!! end
function unique!! end

include("NoBang/NoBang.jl")
using .NoBang: Empty, SingletonVector, singletonof

include("core.jl")
include("base.jl")
include("linearalgebra.jl")
include("extras.jl")
include("broadcast.jl")
include("collectors.jl")
include("initials.jl")
include("macro.jl")
include("dataframes_impl.jl")
include("chainrules.jl")

include("setfield.jl")
using .SetfieldImpl: @set!!, prefermutation

function __init__()
    @require StaticArrays = "90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
    @require StructArrays = "09ab397b-f2b6-538f-b94a-2f83cf4a842a" begin
        include("structarrays.jl")
    end
    @require TypedTables = "9d95f2ec-7b3d-5a63-8d20-e2491e220bb9" begin
        include("typedtables.jl")
    end
    @require DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0" begin
        include("dataframes.jl")
    end
end

end # module
