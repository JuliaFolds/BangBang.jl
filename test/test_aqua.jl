module TestAqua

using Aqua
using BangBang
using Setfield
using Test

Aqua.test_all(
    BangBang;
    ambiguities=(exclude=[Base.get, Setfield.set, Setfield.modify],),
    project_extras = true,
    stale_deps = true,
    deps_compat = true,
    project_toml_formatting = true,
)

end  # module
