using BangBang
using LinearAlgebra

function rnn!!(n, J, x)
    dest = x
    y = similar(x)
    for _ in 1:n
        @! y = mul!(y, J, x)
        @! y .= tanh.(y)
        x, y = y, x
    end
    @! dest .= x
    return dest
end

using Zygote
d = 10
J = randn(d, d)
x0 = randn(d)
y_target = randn(d)
g, = Zygote.gradient(J -> sum((rnn!!(20, J, x0) .- y_target) .^ 2), J)
