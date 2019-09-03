push(xs::StaticArrays.StaticVector, x) = vcat(xs, StaticArrays.SVector(x))
