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
    strict = [
        :autodocs_block,
        :cross_references,
        :docs_block,
        :doctest,
        :eval_block,
        :example_block,
        :footnote,
        :linkcheck,
        :meta_block,
        # Ignoring `:missing_docs` since Documenter does not handle docstrings
        # defined outside the sub-module nicely:
        # :missing_docs,
        :parse_error,
        :setup_block,
    ],
    # Ref:
    # https://juliadocs.github.io/Documenter.jl/stable/lib/public/#Documenter.makedocs
)

deploydocs(; repo = "github.com/JuliaFolds/BangBang.jl", push_preview = true)
