var documenterSearchIndex = {"docs":
[{"location":"#BangBang.jl-1","page":"Home","title":"BangBang.jl","text":"","category":"section"},{"location":"#","page":"Home","title":"Home","text":"","category":"page"},{"location":"#","page":"Home","title":"Home","text":"Modules = [BangBang]","category":"page"},{"location":"#BangBang.BangBang","page":"Home","title":"BangBang.BangBang","text":"BangBang\n\n(Image: Stable) (Image: Dev) (Image: Build Status) (Image: Codecov) (Image: Coveralls) (Image: Aqua QA) (Image: GitHub commits since tagged version)\n\nBangBang.jl implements functions whose name ends with !!.  Those functions provide a uniform interface for mutable and immutable data structures.  Furthermore, those function implement the \"widening\" fallback for the case the usual mutating function does not work (e.g., push!!(Int[], 1.5) creates a new array Float64[1.5]).\n\nSee the supported functions in the documentation\n\n\n\n\n\n","category":"module"},{"location":"#BangBang.append!!-Tuple{Any,Any}","page":"Home","title":"BangBang.append!!","text":"append!!(dest, src)\n\nAppend items in src to dest.  Mutate dest if possible.  See also push!!.\n\nExamples\n\njulia> using BangBang\n\njulia> append!!((1, 2), (3, 4))\n(1, 2, 3, 4)\n\njulia> append!!([1, 2], (3, 4))\n4-element Array{Int64,1}:\n 1\n 2\n 3\n 4\n\njulia> using StructArrays: StructVector\n\njulia> @assert append!!(StructVector(a=[1], b=[2]), [(a=3.5, b=4.5)]) ==\n           StructVector(a=[1.0, 3.5], b=[2.0, 4.5])\n\njulia> using TypedTables: Table\n\njulia> @assert append!!(Table(a=[1], b=[2]), [(a=3.5, b=4.5)]) ==\n           Table(a=[1.0, 3.5], b=[2.0, 4.5])\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.delete!!-Tuple{Any,Any}","page":"Home","title":"BangBang.delete!!","text":"delete!!(assoc, key) -> assoc′\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.empty!!-Tuple{Any}","page":"Home","title":"BangBang.empty!!","text":"empty!!(collection) -> collection′\n\nExamples\n\njulia> using BangBang\n\njulia> empty!!((1, 2, 3))\n()\n\njulia> empty!!((a=1, b=2, c=3))\nNamedTuple()\n\njulia> xs = [1, 2, 3];\n\njulia> empty!!(xs)\n0-element Array{Int64,1}\n\njulia> xs\n0-element Array{Int64,1}\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.lmul!!-Tuple{Any,Any}","page":"Home","title":"BangBang.lmul!!","text":"lmul!!(A, B) -> B′\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.materialize!!-Tuple{Any,Any}","page":"Home","title":"BangBang.materialize!!","text":"materialize!!(dest, x)\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.mul!!-Tuple{Any,Any,Any}","page":"Home","title":"BangBang.mul!!","text":"mul!!(C, A, B, [α, β]) -> C′\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.pop!!-Tuple{Any,Vararg{Any,N} where N}","page":"Home","title":"BangBang.pop!!","text":"pop!!(sequence) -> (sequence′, value)\npop!!(assoc, key) -> (assoc′, value)\npop!!(assoc, key, default) -> (assoc′, value)\n\nExamples\n\njulia> using BangBang\n\njulia> pop!!([0, 1])\n([0], 1)\n\njulia> pop!!((0, 1))\n((0,), 1)\n\njulia> pop!!(Dict(:a => 1), :a)\n(Dict{Symbol,Int64}(), 1)\n\njulia> pop!!((a=1,), :a)\n(NamedTuple(), 1)\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.popfirst!!-Tuple{Any}","page":"Home","title":"BangBang.popfirst!!","text":"popfirst!!(sequence) -> (sequence′, value)\n\nExamples\n\njulia> using BangBang\n\njulia> popfirst!!([0, 1])\n([1], 0)\n\njulia> popfirst!!((0, 1))\n((1,), 0)\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.push!!-Tuple{Any,Any,Any,Vararg{Any,N} where N}","page":"Home","title":"BangBang.push!!","text":"push!!(collection, items...)\n\nPush one or more items to collection.  Create a copy of collection if it cannot be mutated or the element type does not match.\n\nExamples\n\njulia> using BangBang\n\njulia> push!!((1, 2), 3)\n(1, 2, 3)\n\njulia> push!!([1, 2], 3)\n3-element Array{Int64,1}:\n 1\n 2\n 3\n\njulia> push!!([1, 2], 3.0)\n3-element Array{Float64,1}:\n 1.0\n 2.0\n 3.0\n\njulia> using DataFrames: DataFrame\n\njulia> @assert push!!(DataFrame(a=[1], b=[2]), (a=3.5, b=4.5)) ==\n           DataFrame(a=[1.0, 3.5], b=[2.0, 4.5])\n\njulia> using StructArrays: StructVector\n\njulia> @assert push!!(StructVector(a=[1], b=[2]), (a=3.5, b=4.5)) ==\n           StructVector(a=[1.0, 3.5], b=[2.0, 4.5])\n\njulia> using TypedTables: Table\n\njulia> @assert push!!(Table(a=[1], b=[2]), (a=3.5, b=4.5)) ==\n           Table(a=[1.0, 3.5], b=[2.0, 4.5])\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.pushfirst!!-Tuple{Any,Vararg{Any,N} where N}","page":"Home","title":"BangBang.pushfirst!!","text":"pushfirst!!(collection, items...)\n\nExamples\n\njulia> using BangBang\n\njulia> pushfirst!!((1, 2), 3, 4)\n(3, 4, 1, 2)\n\njulia> pushfirst!!([1, 2], 3, 4)\n4-element Array{Int64,1}:\n 3\n 4\n 1\n 2\n\njulia> pushfirst!!([1, 2], 3, 4.0)\n4-element Array{Float64,1}:\n 3.0\n 4.0\n 1.0\n 2.0\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.rmul!!-Tuple{Any,Any}","page":"Home","title":"BangBang.rmul!!","text":"rmul!!(A, B) -> A′\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.setindex!!-Tuple{Any,Any,Vararg{Any,N} where N}","page":"Home","title":"BangBang.setindex!!","text":"setindex!!(collection, value, indices...) -> collection′\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.setproperty!!-Tuple{Any,Any,Any}","page":"Home","title":"BangBang.setproperty!!","text":"setproperty!!(value, name, x)\n\nExamples\n\njulia> using BangBang\n\njulia> setproperty!!((a=1, b=2), :b, 3)\n(a = 1, b = 3)\n\njulia> struct Immutable\n           a\n           b\n       end\n\njulia> setproperty!!(Immutable(1, 2), :b, 3)\nImmutable(1, 3)\n\njulia> mutable struct Mutable\n           a\n           b\n       end\n\njulia> s = Mutable(1, 2);\n\njulia> setproperty!!(s, :b, 3)\nMutable(1, 3)\n\njulia> s\nMutable(1, 3)\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.splice!!-Tuple{Any,Vararg{Any,N} where N}","page":"Home","title":"BangBang.splice!!","text":"splice!!(sequence, i, [replacement]) -> (sequence′, item)\n\n\n\n\n\n","category":"method"},{"location":"#BangBang.@!-Tuple{Any}","page":"Home","title":"BangBang.@!","text":"@! expr\n\nConvert all supported mutating calls to double bang equivalent.\n\nExamples\n\njulia> using BangBang\n\njulia> @! push!(empty!((0, 1)), 2, 3)\n(2, 3)\n\njulia> y = [1, 2];\n\njulia> @! y .= 2 .* y\n       y\n2-element Array{Int64,1}:\n 2\n 4\n\njulia> y = (1, 2);\n\njulia> @! y .= 2 .* y\n       y\n(2, 4)\n\n\n\n\n\n","category":"macro"}]
}
