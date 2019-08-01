using BangBang

struct UndefArray{N, T <: NTuple{N, Int}} <: AbstractArray{Union{}, N}
    size::T
end

Base.size(arr::UndefArray) = arr.size
Base.isassigned(::UndefArray, ::Integer...) = false

function BangBang.NoBang._setindex(x::UndefArray{N}, v, I...) where N
    ys = Array{typeof(v), N}(undef, x.size...)
    ys[I...] = v
    return ys
end


mapbb(f, xs::Array, inbounds::Val = Val(true)) =
    __map!!(f, UndefArray(size(xs)), xs, 1, inbounds)


@inline function __map!!(f, ys, xs, n, inbounds)
    @simd for i in n:length(ys)
        if inbounds === Val(true)
            @inbounds begin
                ys′ = setindex!!(ys, f(xs[i]), i)
            end
        else
            ys′ = setindex!!(ys, f(xs[i]), i)
        end
        if !(ys′ isa typeof(ys))
            return __map!!(f, ys′, xs, i + 1, inbounds)
        end
    end
    return ys
end
