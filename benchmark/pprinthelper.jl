using JSON
using Markdown
using PkgBenchmark

function displayresult(result)
    md = sprint(export_markdown, result)
    md = replace(md, ":x:" => "❌")
    md = replace(md, ":white_check_mark:" => "✅")
    display(Markdown.parse(md))
end

function printnewsection(name)
    println()
    println()
    println()
    printstyled("▃" ^ displaysize(stdout)[2]; color=:blue)
    println()
    printstyled(name; bold=true)
    println()
    println()
end

function printcommentmd(io; group_target, group_baseline, judgement)
    println(io, "<details>")
    println(io, "<summary>Benchmark result</summary>")
    println(io)
    println(io, "# Judge result")
    export_markdown(io, judgement)
    println(io)
    println(io)
    println(io, "# Target result")
    export_markdown(io, group_target)
    println(io)
    println(io)
    println(io, "# Baseline result")
    export_markdown(io, group_baseline)
    println(io)
    println(io)
    println(io, "</details>")
end

function printcommentjson(io; kwargs...)
    comment = sprint() do io
        printcommentmd(io; kwargs...)
    end
    println(comment)
    # https://developer.github.com/v3/issues/comments/#create-a-comment
    JSON.print(io, Dict("body" => comment))
end
