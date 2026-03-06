"WC Model"
module WCModel
export WCParams, sig, sigd, I_null, rhs, fIext_E, correct
struct WCParams
    wEE::Float64; wEI::Float64; wIE::Float64; wII::Float64
    τE::Float64;  τI::Float64
    aE::Float64;  aI::Float64
    θE::Float64;  θI::Float64
    Iext_E::Float64; Iext_I::Float64
end

function correct(a, θ)
    c = 1.0 / (1.0 + exp(a * θ))
    return c
end
function sig(x, a, θ)
    "sigmoid function"
    c = correct(a,θ)
    return 1.0 / (1.0 + exp(-a * (x - θ))) - c
end

function sigd(x, a, θ)
    c = correct(a,θ)
    F = sig(x, a, θ)
    return a * (F + c) * (1.0 - F - c)
end

function sigdr(r, a, θ)
    c = correct(a, θ)
    return a * (r + c) * (1.0 - r - c)
end

function siginv(x,a,θ)
    c = correct(a, θ)
    return θ - (1.0 / a) * log((1.0 / (x + c)) - 1.0)
end

function I_null(rI, p::WCParams)
    rE = 1/p.wIE * (p.wII*rI + siginv(rI,p.aI,p.θI)-p.Iext_I)
    return rE
end

function fIext_E(rE,rI,p::WCParams)
    Iext_E = siginv(rE,p.aE,p.θE)-p.wEE*rE+p.wEI*rI
    return Iext_E
end

function rhs(rI, p::WCParams)
    "R(r_I)"
    cI = correct(p.aI,p.θI)
    cE = correct(p.aE,p.θE)
    β = p.aI * (rI+cI) * (1.0-rI-cI)
    rE = I_null(rI,p)
    α = p.aE * (rE+cE) * (1.0-rE-cE)
    R = p.τE/p.τI * ((1 + p.wII * β)^2) / (α * β)
    return R
end
end
