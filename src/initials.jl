InitialValues.@def push!! [x]

@static if isdefined(InitialValues, Symbol("@def_monoid"))
    InitialValues.@def_monoid append!!
else
    InitialValues.@def append!!
end
