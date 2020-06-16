# BangBang

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://juliafolds.github.io/BangBang.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://juliafolds.github.io/BangBang.jl/dev)
[![Build Status](https://travis-ci.com/JuliaFolds/BangBang.jl.svg?branch=master)](https://travis-ci.com/JuliaFolds/BangBang.jl)
[![Codecov](https://codecov.io/gh/JuliaFolds/BangBang.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaFolds/BangBang.jl)
[![Coveralls](https://coveralls.io/repos/github/JuliaFolds/BangBang.jl/badge.svg?branch=master)](https://coveralls.io/github/JuliaFolds/BangBang.jl?branch=master)
[![Aqua QA](https://img.shields.io/badge/Aqua.jl-%F0%9F%8C%A2-aqua.svg)](https://github.com/tkf/Aqua.jl)
[![GitHub commits since tagged version](https://img.shields.io/github/commits-since/JuliaFolds/BangBang.jl/v0.3.26.svg?style=social&logo=github)](https://github.com/JuliaFolds/BangBang.jl)

BangBang.jl implements functions whose name ends with `!!`.  Those
functions provide a uniform interface for mutable and immutable data
structures.  Furthermore, those function implement the "widening"
fallback for the case the usual mutating function does not work (e.g.,
`push!!(Int[], 1.5)` creates a new array `Float64[1.5]`).

See the supported functions in the
[documentation](https://juliafolds.github.io/BangBang.jl/dev)
