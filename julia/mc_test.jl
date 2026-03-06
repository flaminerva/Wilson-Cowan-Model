# This is still in process. 
# Currently we haven't completed the random 5000 test, but only the algo itself.
using DifferentialEquations
include("model.jl")
using .WCModel


function hopf(rI,rE,p::WCParams)
    "τ > 0 and Δ > 0"
    uE = p.wEE * rE - p.wEI * rI + p.Iext_E
    uI = p.wIE * rE - p.wII * rI + p.Iext_I
    FpE = sigd(uE, p.aE, p.θE)
    FpI = sigd(uI, p.aI, p.θI)

    J11 = (-1.0 + p.wEE * FpE) / p.τE
    J12 = (-p.wEI * FpE) / p.τE
    J21 = (p.wIE * FpI) / p.τI
    J22 = (-1.0 - p.wII * FpI) / p.τI

    τ = J11 + J22
    Δ = J11 * J22 - J12 * J21

    if τ>0 && Δ>0
        return true
    else
        return false
    end
end

function full_check(p::WCParams)
    "range of rI in [-cI, 1 - cI]"
    cI = correct(p.aI,p.θI)
    rIval = -cI:0.001:1-cI

    R = rhs.(rIval,Ref(p))
    rE = I_null.(rIval,Ref(p))
    Iext = fIext_E.(rE,rIval,Ref(p))

    minR = minimum(R)
    if  minR > p.wEI*p.wIE
        return false
    end

    h = hopf.(rIval,rE,Ref(p))
    dI = diff(Iext)
    foldin = findall(i -> dI[i]*dI[i+1]<0, 1:length(dI)-1)

    if isempty(foldin)
        return any(h)
    end

    fold_lo = foldin[begin]
    fold_hi = foldin[end]

    for i in eachindex(rIval)
        if h[i] && (i < fold_lo || i > fold_hi)
            return true
        end
    end

    return false
end