using Test
using Base: ImmutableDict
using BangBang
using BangBang: implements
using StaticArrays: SVector

"""
    ==ₜ(x, y)

Check that _type_ and value of `x` and `y` are equal.
"""
==ₜ(_, _) = false
==ₜ(x::T, y::T) where T = x == y

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
