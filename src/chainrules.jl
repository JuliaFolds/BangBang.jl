# https://fluxml.ai/Zygote.jl/dev/adjoints/#Gradient-Reflection-1

# Treat everything immutable during differentiation:
ChainRulesCore.rrule(::typeof(possible), _...) = false, _ -> ChainRulesCore.NoTangent()
