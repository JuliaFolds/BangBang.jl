module TestDataFrames

using BangBang: append!!, push!!
using CategoricalArrays: CategoricalArray
using DataFrames: DataFrame
using Tables: Tables
using Test

@testset "push!!" begin
    @testset "column: $(typeof(column)); row: $(typeof(row))" for (column, row) in [
        ([0], (a = 1,)),
        ([0], Dict(:a => 1)),
        ([0], [1]),
        ([0], (1,)),
        ([0.5], (a = 1,)),
        ([0.5], Dict(:a => 1)),
        ([0.5], [1]),
        ([0.5], (1,)),
        ([0], (a = 1.5,)),
        (CategoricalArray(["A", "B"]), (a = "A",)),
        (CategoricalArray(["A", "B"]), (a = "C",)),
    ]
        df = DataFrame(a = copy(column))
        # row isa DataFrame
        # row[:, :a] .+= 1
        if row isa Union{Array, Tuple}
            df2 = DataFrame(a=row[1])
        else
            df2 = DataFrame([(; pairs(row)...)])
        end
        @test push!!(copy(df), row) == vcat(df, df2)
        @test push!(push!!(copy(df), row), row) isa DataFrame
    end
end

@testset "push!!(::DataFrame, ::IteratorRow)" begin
    @testset "column: $(typeof(column)); row: $(typeof(row))" for (column, row) in [
        ([0], Tables.IteratorRow((a = 1,))),
        ([0.5], Tables.IteratorRow((a = 1,))),
    ]
        df = DataFrame(a = copy(column))
        df2 = DataFrame([(a = 1,)])
        @test push!!(copy(df), row) == vcat(df, df2)
    end
end

@testset "append!!" begin
    @testset "column: $(typeof(column)); source: $(typeof(source))" for (
        column,
        source,
    ) in [
        ([0], ((a = 1,),)),
        ([0], [(a = 1,)]),
        ([0], (a = [1],)),
        # ([0], Dict(:a => [1])),
        ([0], DataFrame(a = [1])),
        ([0.5], ((a = 1,),)),
        ([0.5], [(a = 1,)]),
        ([0.5], (a = [1],)),
        ([0.5], DataFrame(a = [1])),
        ([0], ((a = 1.5,),)),
        ([0], [(a = 1.5,)]),
        ([0], (a = [1.5],)),
        ([0], DataFrame(a = [1.5])),
        (CategoricalArray(["A", "B"]), ((a = "A",),)),
        (CategoricalArray(["A", "B"]), [(a = "A",)]),
        (CategoricalArray(["A", "B"]), (a = ["A"],)),
        (CategoricalArray(["A", "B"]), ((a = "C",),)),
        (CategoricalArray(["A", "B"]), [(a = "C",)]),
        (CategoricalArray(["A", "B"]), (a = ["C"],)),
    ]
        df = DataFrame(a = copy(column))
        # source isa DataFrame
        # source[:, :a] .+= 1
        @test append!!(copy(df), source) == vcat(df, DataFrame(source))
    end
end

end  # module
