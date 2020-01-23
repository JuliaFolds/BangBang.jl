using BenchmarkTools
SUITE = BenchmarkGroup()
SUITE["nothing"] = @benchmarkable nothing
