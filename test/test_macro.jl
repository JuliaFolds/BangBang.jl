module TestMacro

include("preamble.jl")

@testset begin
    @test (@! push!(empty!([0, 1]), 2, 3)) == [2, 3]
    @test (@! push!(empty!((0, 1)), 2, 3)) == (2, 3)
end

@testset ".=" begin
    @test !@isdefined y
    @test begin
        x = SVector(1, 2)
        @! y .= x .* 2
    end === SVector(2, 4)

    @test !@isdefined y
    @test begin
        x = SVector(1, 2)
        y = SVector(0, 0)
        @! y .= x .* 2
    end === SVector(2, 4)

    let x = [1, 2]
        y = [0, 0]
        @test (@! y .= x .* 2)::Vector{Int} == [2, 4]
    end

    let x = [1, 2]
        y = SVector(0, 0)
        @test (@! y .= x .* 2)::Vector{Int} == [2, 4]
    end
end

@testset "@." begin
    @test !@isdefined y
    @test begin
        x = SVector(1, 2)
        @! @. y = x * 2
    end === SVector(2, 4)

    @test !@isdefined y
    @test begin
        x = SVector(1, 2)
        y = SVector(0, 0)
        @! @. y = x * 2
    end === SVector(2, 4)

    let x = [1, 2]
        y = [0, 0]
        @test (@! @. y = x * 2)::Vector{Int} == [2, 4]
    end

    let x = [1, 2]
        y = SVector(0, 0)
        @test (@! @. y = x * 2)::Vector{Int} == [2, 4]
    end
end

end  # module
