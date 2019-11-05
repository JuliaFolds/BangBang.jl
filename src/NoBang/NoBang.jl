module NoBang

export Empty, singletonof

using Base.Iterators: Pairs
using Base: ImmutableDict
using Requires
using ConstructionBase: constructorof, setproperties
using Tables: Tables

using ..BangBang: push!!, ismutable

if VERSION < v"1.1-"
    using Future: copy!
end

include("singletoncontainers.jl")
include("base.jl")
include("linearalgebra.jl")
include("singletonof.jl")
include("emptycontainers.jl")

function __init__()
    @require StaticArrays="90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
end

end  # module
