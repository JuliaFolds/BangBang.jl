module BangBang

export push!!, append!!

include("NoBang/NoBang.jl")
using .NoBang: push, append

include("core.jl")
include("base.jl")

end # module
