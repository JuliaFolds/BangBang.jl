module BangBang

export push!!, append!!

using Requires

include("NoBang/NoBang.jl")
using .NoBang: ImmutableContainer, push, append

include("core.jl")
include("base.jl")

function __init__()
    @require StaticArrays="90137ffa-7385-5640-81b9-e52037218182" begin
        include("staticarrays.jl")
    end
end

end # module
