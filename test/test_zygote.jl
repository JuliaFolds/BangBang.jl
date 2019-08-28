module TestZygote

include("preamble.jl")
using Zygote

include("../examples/zygote.jl")
@test g isa Matrix
@test size(g) == (d, d)

end  # module
