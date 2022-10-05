# BangBang

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliafolds.github.io/BangBang.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliafolds.github.io/BangBang.jl/dev)
[![Codecov](https://codecov.io/gh/JuliaFolds/BangBang.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaFolds/BangBang.jl)
[![Aqua QA](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)
[![GitHub commits since tagged version](https://img.shields.io/github/commits-since/JuliaFolds/BangBang.jl/v0.3.38.svg?style=social&logo=github)](https://github.com/JuliaFolds/BangBang.jl)

BangBang.jl implements functions whose name ends with `!!`.  Those
functions provide a uniform interface for mutable and immutable data
structures.  Furthermore, those functions implement the "widening"
fallback for the case when the usual mutating function does not work (e.g.,
`push!!(Int[], 1.5)` creates a new array `Float64[1.5]`).

See the supported functions in the
[documentation](https://juliafolds.github.io/BangBang.jl/dev)
