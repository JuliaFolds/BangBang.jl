using Test
using Base: ImmutableDict
using BangBang
using BangBang: ismutable
using StaticArrays: SVector

macro test_error(ex)
    quote
        let err = nothing
            try
                $(esc(ex))
            catch err
            end
            @test err isa Exception
            err
        end
    end
end

macro test_inferred(ex)
    esc(:($Test.@test (($Test.@inferred $ex); true)))
end
