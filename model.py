from dataclasses import dataclass
import numpy as np

#This is in processing!!! I am just too lazy to use git ignore

# pylint: disable=invalid-name
@dataclass
class WilsonCowanParams:

    '''Wilson Cowan Parameter
    https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html
    '''

    tau_E: float = 1.0 #ms
    tau_I: float = 2.0 #ms
    a_E: float = 1.2
    a_I: float = 1.0
    theta_E: float = 2.8
    theta_I: float = 4.0
    w_EE: float = 9.0
    w_EI: float = 4.0
    w_IE: float = 13.0
    w_II: float = 11.0
    I_E: float =  0.0
    I_I: float = 0.0




class WilsonCowanModel():
    '''Model'''

    def __init__(self):
        pass
    def Jacobian(self,r_E: float, r_I: float, p: WilsonCowanParams) -> np.ndarray:
        '''caculate Jacobian eigenvalues on fixed point (r_E,r_I),
        determine the state of system'''

        def F(x,a,theta):
            return 1.0/(1.0+np.exp(-a*(x-theta))) - 1.0/(1.0+np.exp(a*theta))


        def dF(x,a,theta):
            fx = F(x,a,theta)
            return a * fx * (1.0 - fx)

        u_E = p.w_EE * r_E - p.w_EI * r_I + p.I_E
        u_I = p.w_IE * r_E - p.w_II * r_I + p.I_I
        dF_E = dF(u_E, p.a_E, p.theta_E)
        dF_I = dF(u_I, p.a_I, p.theta_I)

        J11 = (1.0 / p.tau_E) * (-1.0 + p.w_EE * dF_E)
        J12 = (1.0 / p.tau_E) * (-p.w_EI * dF_E)
        J21 = (1.0 / p.tau_I) * (p.w_IE * dF_I)
        J22 = (1.0 / p.tau_I) * (-1.0 - p.w_II * dF_I)

        return np.array([
            [J11,J12],
            [J21,J22]
            ])



params = WilsonCowanParams()
model = WilsonCowanModel()
J = model.Jacobian(0,0,params)
print(J)
eigval = np.linalg.eigvals(J)
print(eigval)

if np.all(np.real(eigval) < 0):
    print("Stable Node / Spiral")
else:
    print("Unstable")



def one_fixed_point(I_e):
    p = WilsonCowanParams(I_E=I_e)

    def F_inv(y, a, theta):
        c = 1 / (1 + np.exp(a * theta))
        return theta + (1/a) * np.log((y + c) / (1 - c - y))

    def I_null(r_I):
        return (1/p.w_IE) * (p.w_II*r_I + F_inv(r_I, p.a_I, p.theta_I) - p.I_I)

    def E_null(r_E):
        return (1/p.w_EI) * (p.w_EE*r_E - F_inv(r_E, p.a_E, p.theta_E) + p.I_E)

    r_I_vals = np.linspace(0, 0.982, 1000)
    solution = []
    diff = []
    for r_I in r_I_vals:
        r_E = I_null(r_I)
        r_Ip = E_null(r_E)
        diff.append(r_Ip-r_I)

    for i in range(len(diff)-1):
        if diff[i]*diff[i+1]<0: # In this interval it has solution
            r_I = (r_I_vals[i]+r_I_vals[i+1])/2
            r_E = I_null(r_I)
            solution.append((r_E,r_I))
        elif abs(diff[i])<1e-8: #(0,0)
            r_I = r_I_vals[i]
            r_E = I_null(r_I)
            solution.append((r_E,r_I))

    return (len(solution),solution) if len(solution)==1 else None

for Ie in np.arange(0, 1, 0.05):
    result = one_fixed_point(Ie)
    if result is None:
        continue
    for r_E, r_I in result[1]:
        J = model.Jacobian(r_E, r_I, params)
        eigval = np.linalg.eigvals(J)
        if np.all(np.real(eigval) < 0):
            print(f"I_e={Ie:.2f}: Stable")
        else:
            print(f"I_e={Ie:.2f}: Unstable")