module NoBang

using Base.Iterators: Pairs
using Base: ImmutableDict
using Requires
using Setfield: setproperties

include("singletoncontainers.jl")
include("core.jl")
include("base.jl")
include("linearalgebra.jl")

function __init__()
    @require StaticArrays="90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
end

end  # module
