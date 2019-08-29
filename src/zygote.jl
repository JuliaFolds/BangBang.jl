# https://fluxml.ai/Zygote.jl/dev/adjoints/#Gradient-Reflection-1

# Treat everything immutable during differentiation:
@adjoint possible(_args...) = false, _ -> nothing
