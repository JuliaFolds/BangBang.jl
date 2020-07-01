using BangBang
using Documenter
using JSON

function should_push_preview(event_path = get(ENV, "GITHUB_EVENT_PATH", nothing))
    event_path === nothing && return false
    event = JSON.parsefile(event_path)
    pull_request = get(event, "pull_request", nothing)
    pull_request === nothing && return false
    labels = [x["name"] for x in pull_request["labels"]]
    # https://developer.github.com/v3/activity/events/types/#pullrequestevent
    yes = "push_preview" in labels
    if yes
        @info "Trying to push preview as label `push_preview` is specified." labels
    else
        @info "Not pushing preview as label `push_preview` is not specified." labels
    end
    return yes
end

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
    strict = true,
)

deploydocs(;
    repo = "github.com/JuliaFolds/BangBang.jl",
    push_preview = should_push_preview(),
)
