module BangBang

export push!!

include("NoBang/NoBang.jl")
using .NoBang: push

include("base.jl")

end # module
