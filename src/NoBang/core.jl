_foldlsome(op, x) = x
@inline function _foldlsome(op, x1, x2, xs...)
    result = op(x1, x2)
    result isa Some && return result
    return _foldlsome(op, result, xs...)
end

function _findfirst(xs, x)
    found = _foldlsome(1, xs...) do i, y
        y == x ? Some(i) : i + 1
    end
    found isa Some || return nothing
    return something(found)
end
