module TestAqua

using Aqua
using BangBang
using Setfield
using Test

Aqua.test_all(
    BangBang;
    ambiguities=(exclude=[Base.get, Setfield.set, Setfield.modify],),
)

@testset "Compare test/Project.toml and test/environments/main/Project.toml" begin
    @test Text(read(joinpath(@__DIR__, "Project.toml"), String)) ==
          Text(read(joinpath(@__DIR__, "environments", "main", "Project.toml"), String))
end

end  # module
