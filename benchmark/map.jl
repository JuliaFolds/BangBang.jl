using BangBang


mapbb(f, xs::Array, inbounds::Val = Val(true)) =
    __map!!(f, similar(xs, Union{}), xs, 1, inbounds)


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
