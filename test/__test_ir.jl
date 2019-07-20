using InteractiveUtils: code_llvm
using Test

include("../benchmark/map.jl")

"""
    llvm_ir(f, args) :: String

Get LLVM IR of `f(args...)` as a string.
"""
llvm_ir(f, args) = sprint(code_llvm, f, Base.typesof(args...))

nmatches(r, s) = count(_ -> true, eachmatch(r, s))

twice(x) = 2x

@testset "setindex!! (@inbounds)" begin
    @test mapbb(twice, [1:3;], Val(false)) == [2, 4, 6]

    ir_noinbounds = llvm_ir(mapbb, (twice, Float64[], Val(false)))
    if Base.JLOptions().check_bounds == 2  # --check-bounds=no
        @test nmatches(r"fmul <4 x double>", ir_noinbounds) >= 4
    else
        @test nmatches(r"fmul <4 x double>", ir_noinbounds) == 0
    end
    ir_inbounds = llvm_ir(mapbb, (twice, Float64[], Val(true)))
    @test nmatches(r"fmul <4 x double>", ir_inbounds) >= 4
end
