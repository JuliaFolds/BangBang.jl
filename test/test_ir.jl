module TestIR

using CpuId

show(stdout, "text/plain", cpuinfo())
println()
show(stdout, "text/plain", cpufeaturetable())
println()

using IRTest
IRTest.@include("__test_ir.jl")

end  # module
