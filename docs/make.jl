using Documenter, BangBang

makedocs(
    ;
    modules = [BangBang],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        hide("internals.md"),
    ],
    repo = "https://github.com/JuliaFolds/BangBang.jl/blob/{commit}{path}#L{line}",
    sitename = "BangBang.jl",
    authors = "Takafumi Arakaki <aka.tkf@gmail.com>",
    doctest = false,  # run via tests
    strict = true,
)

deploydocs(; repo = "github.com/JuliaFolds/BangBang.jl", push_preview = true)
