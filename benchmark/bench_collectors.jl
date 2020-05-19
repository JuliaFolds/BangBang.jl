module BenchCollectors

using BangBang: collector, finish!, push!!
using BenchmarkTools: @benchmarkable, BenchmarkGroup
using SplittablesBase: amount

function map_manual(f, src)
    dest = similar(src)
    for i in eachindex(src, dest)
        @inbounds dest[i] = f(src[i])
    end
    return dest
end

function map_collector(f, src, unsafe = Val(true))
    dest = similar(src)
    c = collector(dest, unsafe)
    for x in src
        c = push!!(c, f(x))
    end
    return finish!(c)
end

function map_vector(f, src)
    dest = eltype(src)[]
    for x in src
        dest = push!!(dest, f(x))
    end
    return dest
end

@inline function _foldl(op, acc::T, itr) where {T}
    y = iterate(itr)
    y === nothing && return acc
    (x, state) = y
    result = op(acc, x)
    if result isa T
        return _foldl(op, result, itr, state)
    else
        return _foldl(op, result, itr, state)
    end
end

@inline function _foldl(op, acc::T, itr, state) where {T}
    while true
        y = iterate(itr, state)
        y === nothing && return acc
        (x, state) = y
        result = op(acc, x)
        if result isa T
            acc = result
        else
            return _foldl(op, result, itr, state)
        end
    end
end

const vec0 = Union{}[]

collect_collector(src) = finish!(_foldl(push!!, collector(vec0), src))

collect_vector(src) = _foldl(push!!, vec0, src)

collect_collector_nonexpanding(src) =
    finish!(_foldl(push!!, collector(resize!(Union{}[], amount(src)), Val(true)), src))

double(x) = 2 * x

suite = BenchmarkGroup()

let s0 = suite[:comp=>"map"] = BenchmarkGroup()
    xs = 1:10_000
    @assert map_manual(double, xs) == map_collector(double, xs) == map_vector(double, xs)
    s0[:impl=>"man"] = @benchmarkable(map_manual(double, $xs))
    s0[:impl=>"coll"] = @benchmarkable(map_collector(double, $xs))
    s0[:impl=>"safe_coll"] = @benchmarkable(map_collector(double, $xs, Val(false)))
    s0[:impl=>"vec"] = @benchmarkable(map_vector(double, $xs))
end

let s0 = suite[:comp=>"filter"] = BenchmarkGroup()
    xs = (x for x in 1:10_000 if isodd(x))
    @assert collect(xs) ==
            collect_collector(xs) ==
            collect_vector(xs) ==
            collect_collector_nonexpanding(xs)
    s0[:impl=>"base"] = @benchmarkable(collect($xs))
    s0[:impl=>"coll"] = @benchmarkable(collect_collector($xs))
    s0[:impl=>"vec"] = @benchmarkable(collect_vector($xs))
    s0[:impl=>"nonexpanding"] = @benchmarkable(collect_collector_nonexpanding($xs))
end

end  # module
BenchCollectors.suite
