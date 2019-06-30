using Documenter, BangBang

makedocs(;
    modules=[BangBang],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/tkf/BangBang.jl/blob/{commit}{path}#L{line}",
    sitename="BangBang.jl",
    authors="Takafumi Arakaki <aka.tkf@gmail.com>",
)

deploydocs(;
    repo="github.com/tkf/BangBang.jl",
)
