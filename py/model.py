"""Wilson-Cowan neural population model."""
from dataclasses import dataclass,replace
import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import brentq
import visual as vis


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


def _F(x, a, theta):
    """Transfer function (shifted sigmoid)."""
    return 1.0 / (1.0 + np.exp(-a * (x - theta))) - 1.0 / (1.0 + np.exp(a * theta))


def _dF(x, a, theta):
    """Derivative of transfer function."""
    f = _F(x, a, theta)
    c = 1.0 / (1.0 + np.exp(a * theta))
    return a * (f + c) * (1.0 - f - c)


def _F_inv(y, a, theta):
    """Inverse of transfer function."""
    c = 1.0 / (1.0 + np.exp(a * theta))
    return theta + (1.0 / a) * np.log((y + c) / (1.0 - c - y))


class WilsonCowanModel():
    '''Model'''

    def __init__(self, p: WilsonCowanParams):
        self.p = p

    def with_para(self,**overrides)-> "WilsonCowanModel":
        '''return modified para model'''
        return WilsonCowanModel(replace(self.p, **overrides))


    def Jacobian(self,r_E: float, r_I: float) -> np.ndarray:
        '''caculate Jacobian eigenvalues on fixed point (r_E,r_I),
        determine the state of system'''
        p = self.p
        u_E = p.w_EE * r_E - p.w_EI * r_I + p.I_E
        u_I = p.w_IE * r_E - p.w_II * r_I + p.I_I
        dF_E = _dF(u_E, p.a_E, p.theta_E)
        dF_I = _dF(u_I, p.a_I, p.theta_I)

        J11 = (1.0 / p.tau_E) * (-1.0 + p.w_EE * dF_E)
        J12 = (1.0 / p.tau_E) * (-p.w_EI * dF_E)
        J21 = (1.0 / p.tau_I) * (p.w_IE * dF_I)
        J22 = (1.0 / p.tau_I) * (-1.0 - p.w_II * dF_I)

        return np.array([
            [J11,J12],
            [J21,J22]
            ])

    def _I_null(self,r_I:float) -> float:
        '''input r_I return r_E'''
        p = self.p
        return (1/p.w_IE) * (p.w_II*r_I + _F_inv(r_I, p.a_I, p.theta_I) - p.I_I)

    def _E_null(self,r_E:float) -> float:
        '''input r_E return r_I'''
        p = self.p
        return (1/p.w_EI) * (p.w_EE*r_E - _F_inv(r_E, p.a_E, p.theta_E) + p.I_E)
    

    def find_fixed_point(self) -> list[tuple[float,float]] | None:
        '''find all fixed point'''
        r_I_vals = np.linspace(0, 0.982, 1000)
        solution = []
        diff = []
        for r_I in r_I_vals:
            r_E = self._I_null(r_I)
            r_Ip = self._E_null(r_E)
            diff.append(r_Ip-r_I)

        for i in range(len(diff)-1):
            if diff[i]*diff[i+1]<0: # In this interval it has solution
                r_I_star = brentq(
                lambda r_I: self._E_null(self._I_null(r_I)) - r_I,
                r_I_vals[i], r_I_vals[i + 1]
            )
                r_E_star = self._I_null(r_I_star)
                solution.append((r_E_star, r_I_star))
            elif abs(diff[i])<1e-8: #(0,0)
                r_I = r_I_vals[i]
                r_E = self._I_null(r_I)
                solution.append((r_E,r_I))

        return solution

    def state_system(self,r_E:float,r_I:float) -> str:
        '''classify state of system'''
        J = self.Jacobian(r_E,r_I)
        eigval = np.linalg.eigvals(J)
        real_parts = np.real(eigval)
        has_imag = np.any(np.abs(np.imag(eigval)) > 1e-10)
        det = np.linalg.det(J)


        if det < 0:
            return "Saddle Point"
        if np.all(real_parts < 0):
            return "Stable Spiral" if has_imag else "Stable Node"
        return "Unstable Spiral" if has_imag else "Unstable Node"

def sweep(model):
    """parameter space"""
    results = []
    for w_EE in np.arange(5, 25, 0.5):
        for w_II in np.arange(0, 20, 0.5):
            found_oscillatory = False
            for I_E in np.arange(0, 5, 0.05):
                m = model.with_para(w_EE=w_EE, w_II=w_II, I_E=I_E)
                fps = m.find_fixed_point()
                if fps:
                    has_stable = any(
                        np.linalg.det(m.Jacobian(r_E, r_I)) > 0
                        and np.trace(m.Jacobian(r_E, r_I)) < 0
                        for r_E, r_I in fps
                    )
                    if not has_stable:
                        found_oscillatory = True
                        break
            results.append((w_EE, w_II, found_oscillatory))
    return results

def main():
    '''run'''

    PARAM_PRESETS = {
        "default": {}, #bistable
        "oscillatory": dict(w_EE=16.0, w_EI = 26.0, w_IE=20.0,
                             w_II=1.0, tau_E=20.0, tau_I=10.0, theta_E=5.0, theta_I=20.0, I_I=7),
    }

    def make_params(name: str, **overrides) -> WilsonCowanParams:
        return WilsonCowanParams(**{**PARAM_PRESETS[name], **overrides})

    p1 = make_params("oscillatory")
    p2 = make_params("default")
    model = WilsonCowanModel(p1)
    model1 = WilsonCowanModel(p2)
    fixed_point = []
    fixed_point1 = []
    for Ie in np.arange(0, 2, 0.05):
        m = model.with_para(I_E=Ie)
        m1 = model1.with_para(I_E=Ie)
        result = m.find_fixed_point()
        result1 = m1.find_fixed_point()
        if result:
            for r_E, r_I in result:  # pylint: disable=not-an-iterable
                state = m.state_system(r_E,r_I)
                fixed_point.append(((Ie,r_E),state))
                print(f"oscillatory I_E={Ie:.2f}: {state}")

        if result1:
            for r_E, r_I in result1: # pylint: disable=not-an-iterable
                state = m1.state_system(r_E,r_I)
                fixed_point1.append(((Ie,r_E),state))
                J = m1.Jacobian(r_E, r_I)
                tau = np.trace(J)
                delta = np.linalg.det(J)
                disc = tau**2 - 4*delta
                u_I = p2.w_IE * r_E - p2.w_II * r_I + p2.I_I
                dF_I = _dF(u_I, p2.a_I, p2.theta_I)
                u_E = p2.w_EE * r_E - p2.w_EI * r_I + Ie
                dF_E = _dF(u_E, p2.a_E, p2.theta_E)
                print(f"bistable I_E={Ie:.2f}: ({r_E:.4f},{r_I:.4f}) τ={tau:.4f} Δ={delta:.4f} disc={disc:.4f} F'_E={dF_E:.4f} F'_I={dF_I:.4f} -> {state}")

    fig, (ax2, ax1) = plt.subplots(1, 2, figsize=(12, 5))
    vis.plot_fixed_points(fixed_point, ax=ax1, label="Oscillatory")
    vis.plot_fixed_points(fixed_point1, ax=ax2, label="Bistable (NMA)")
    plt.tight_layout()
    fig.savefig('figures/fixed_points.png', dpi=200)
    plt.show()

    fig, (ax2) = plt.subplots(1, 1, figsize=(7, 5))
    vis.plot_fixed_points(fixed_point1, ax=ax2, label="Bistable (NMA)")
    plt.tight_layout()
    fig.savefig('figures/nma.png', dpi=100)
    plt.show()


    fig, (ax2, ax1) = plt.subplots(1, 2, figsize=(12, 5))
    vis.plot_phase_plane(model, ax=ax1, label="Oscillatory")
    vis.plot_phase_plane(model1, ax=ax2, label="Bistable (NMA)")
    plt.tight_layout()
    fig.savefig('figures/phase_plane.png', dpi=200)
    plt.show()

if __name__ == "__main__":
    main()
