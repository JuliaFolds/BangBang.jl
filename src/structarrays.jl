push!!(xs::StructArrays.StructVector, ys...) = append!!(xs, ys)
append!!(xs::StructArrays.StructVector, ys) =
    StructArrays.grow_to_structarray!(xs, ys)
