module TestZygote

if VERSION ≥ v"1.6-"
    try
        using Zygote
    catch
        @info "Failed to import Zygote. Trying again with `@stdlib`..."
        push!(LOAD_PATH, "@stdlib")
    end
end

include("preamble.jl")
using Zygote

include("../examples/zygote.jl")
@test g isa Matrix
@test size(g) == (d, d)

end  # module
