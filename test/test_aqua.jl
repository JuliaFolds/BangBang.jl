module TestAqua

using Aqua
using BangBang
using Setfield

Aqua.test_all(
    BangBang;
    ambiguities=(exclude=[Base.get, Setfield.set, Setfield.modify],),
)

end  # module
