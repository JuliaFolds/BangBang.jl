module BenchDataFrames

using BangBang: push!!
using BenchmarkTools: @benchmarkable, BenchmarkGroup
using CategoricalArrays: CategoricalVector
using DataFrames: DataFrame
using DataStructures: LittleDict

function repeat_push(df, row, n = 10)
    row = LittleDict(keys(row), values(row))
    for _ = 1:n
        foreach(empty!, eachcol(df))
        for i = 1:2^10
            push!!(df, row)
        end
    end
end

mkrow(x) = (; tuple.(Symbol.('a':'a'+(8-1)), x)...)

suite = BenchmarkGroup()

suite["Int-Int"] = @benchmarkable repeat_push($(DataFrame([mkrow(0)])), $(mkrow(0)))
suite["Missing-Int"] = @benchmarkable repeat_push(
    $(DataFrame([mkrow(missing)])),
    $(mkrow(0)),
)
suite["String-String"] = @benchmarkable repeat_push(
    $(DataFrame([mkrow("x")])),
    $(mkrow("x")),
)
suite["Missing-String"] = @benchmarkable repeat_push(
    $(DataFrame([mkrow(missing)])),
    $(mkrow("x")),
)
suite["Categorical"] = @benchmarkable repeat_push(
    $(DataFrame(mkrow(Ref(CategoricalVector(["x"]))))),
    $(mkrow("x")),
)

end  # module
BenchDataFrames.suite
