module TestAqua

using Aqua
using BangBang
using Setfield
using Test

Aqua.test_all(
    BangBang;
    ambiguities=(exclude=[Base.get, Setfield.set, Setfield.modify],),
)

@testset "Stale dependencies" begin
    Aqua.test_stale_deps(BangBang)
end

end  # module
