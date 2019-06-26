module BangBang

export push!!, append!!

include("NoBang/NoBang.jl")
using .NoBang: push, append

include("base.jl")

end # module
