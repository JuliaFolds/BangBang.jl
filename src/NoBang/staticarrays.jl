push(xs::StaticArrays.StaticVector, x) = vcat(xs, StaticArrays.SVector(x))
pushfirst(xs::StaticArrays.StaticVector, x) = StaticArrays.pushfirst(xs, x)
pushfirst(xs::StaticArrays.StaticVector, y, ys...) =
    foldl(pushfirst, (reverse(ys)..., y), init=xs)
pop(xs::StaticArrays.StaticVector) = (StaticArrays.pop(xs), xs[end])
popfirst(xs::StaticArrays.StaticVector) = (StaticArrays.popfirst(xs), xs[1])
deleteat(xs::StaticArrays.StaticVector, i) = StaticArrays.deleteat(xs, i)
_empty(xs::StaticArrays.StaticVector) =
    foldl(ntuple(identity, length(xs)); init=xs) do xs, _
        StaticArrays.pop(xs)
    end
_setindex(xs::StaticArrays.StaticArray, v, I...) = Base.setindex(xs, v, I...)
