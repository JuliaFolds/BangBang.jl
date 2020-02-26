push!!(xs::StructArrays.StructVector, ys...) = append!!(xs, ys)

if isdefined(StructArrays, :append!!)
    append!!(xs::StructArrays.StructVector, ys) =
        StructArrays.append!!(xs, ys)
else
    append!!(xs::StructArrays.StructVector, ys) =
        StructArrays.grow_to_structarray!(xs, ys)
end
