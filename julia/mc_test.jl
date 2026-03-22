# This is still in process. 

using DifferentialEquations
using Distributions
using Random
include("model.jl")
using .WCModel: WCParams, sig, sigd, sigdr, I_null, rhs, fIext_E, correct

Random.seed!(42)

function pbc(rI,rE,p::WCParams)
    "τ > 0 and Δ > 0"
    FdE = sigdr(rE,p.aE,p.θE)
    FdI = sigdr(rI,p.aI,p.θI)

    J11 = (-1.0 + p.wEE * FdE) / p.τE
    J12 = (-p.wEI * FdE) / p.τE
    J21 = (p.wIE * FdI) / p.τI
    J22 = (-1.0 - p.wII * FdI) / p.τI

    τ = J11 + J22
    Δ = J11 * J22 - J12 * J21

    return τ > 0 && Δ > 0
end

function full_check(p::WCParams)
    "range of rI in [-cI, 1 - cI]"
    cI = correct(p.aI,p.θI)
    rIval = range(-cI + 1e-6, 1 - cI - 1e-6, length=1000)

    R = rhs.(rIval,Ref(p))
    rE = I_null.(rIval,Ref(p))
    Iext = fIext_E.(rE,rIval,Ref(p))

    minR = minimum(R)
    if  minR > p.wEI*p.wIE
        return false
    end

    h = pbc.(rIval,rE,Ref(p))
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


function random_params()
    WCParams(
        rand(Uniform(1, 30)),    # wEE
        rand(Uniform(1, 30)),    # wEI
        rand(Uniform(1, 30)),    # wIE
        rand(Uniform(0, 20)),    # wII
        rand(Uniform(0.5, 30)),  # τE
        rand(Uniform(0.5, 30)),  # τI
        rand(Uniform(0.5, 3)),   # aE
        rand(Uniform(0.5, 3)),   # aI
        rand(Uniform(1, 10)),    # θE
        rand(Uniform(1, 20)),    # θI
        rand(Uniform(-2, 5)),    # Iext_E
        rand(Uniform(-2, 5)),    # Iext_I
    )
end


function wc!(du,u,p,t) 
    du[1] = (-u[1] + sig(p.wEE*u[1] - p.wEI*u[2] + p.Iext_E, p.aE, p.θE)) / p.τE
    du[2] = (-u[2] + sig(p.wIE*u[1] - p.wII*u[2] + p.Iext_I, p.aI, p.θI)) / p.τI
end

function detector()
end



function run()
    # Here we use Tsit5(to keep the result same as docu, use RK4)
    sol = nothing
    for i in 1:5000
        p = random_params()
        predic = full_check(p)
        prob = ODEProblem(wc!, [0.1, 0.1], (0.0, 100.0), p)
        sol = solve(prob, Tsit5())
        # sol = solve(prob, RK4()) PLEASE USE RK4 TO KEEP THE RESULT SAME AS IN DOCUMENT.
        # actual = detect_osci(sol)
    end
    return sol
end

sol = run()
println(sol(50.0))