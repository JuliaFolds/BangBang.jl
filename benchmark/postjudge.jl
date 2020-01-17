include("pprinthelper.jl")

group_target = PkgBenchmark.readresults(joinpath(@__DIR__, "result-target.json"))
group_baseline = PkgBenchmark.readresults(joinpath(@__DIR__, "result-baseline.json"))
judgement = judge(group_target, group_baseline)

event_path = ENV["GITHUB_EVENT_PATH"]
event = JSON.parsefile(ENV["GITHUB_EVENT_PATH"])
url = event["pull_request"]["comments_url"]
# https://developer.github.com/v3/activity/events/types/#pullrequestevent

GITHUB_TOKEN = ENV["GITHUB_TOKEN"]
cmd = ```
curl
--request POST
$url
-H "Content-Type: application/json"
-H "Authorization: token $GITHUB_TOKEN"
--data @.
```

open(pipeline(cmd, stdout = stdout, stderr = stderr), write = true) do io
    printcommentjson(
        io;
        group_target = group_target,
        group_baseline = group_baseline,
        judgement = judgement,
    )
end
