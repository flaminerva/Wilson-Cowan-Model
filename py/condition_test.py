'''test'''
from model import WilsonCowanParams, WilsonCowanModel, _dF
import numpy as np

# pylint: disable=invalid-name
def check_condition1(m, r_E, r_I, Ie):
    """
    Condition 1: Lower bound for w_EE (Trace > 0)
    """
    p2 = m.p
    u_I = p2.w_IE * r_E - p2.w_II * r_I + p2.I_I
    dF_I = _dF(u_I, p2.a_I, p2.theta_I)
    u_E = p2.w_EE * r_E - p2.w_EI * r_I + Ie
    dF_E = _dF(u_E, p2.a_E, p2.theta_E)
    threshold = 1.0 + (p2.tau_E / p2.tau_I) * (1.0 + p2.w_II * dF_I)
    return (p2.w_EE * dF_E) > threshold

def check_condition2(m, r_E, r_I, Ie):
    """
    Condition 2: Upper bound for w_EE (Determinant > 0 & No deep saturation)
    """
    p2 = m.p
    u_E = p2.w_EE * r_E - p2.w_EI * r_I + Ie
    dF_E = _dF(u_E, p2.a_E, p2.theta_E)
    
    # 1. Check for deep saturation
    maxim = p2.a_E / 4.0
    not_saturated = dF_E > (0.5 * maxim)
    
    # 2. Check for Determinant collapse (Saddle Point emergence)
    J = m.Jacobian(r_E, r_I)
    det_val = np.linalg.det(J)
    not_collapsed = det_val > 0
    
    return not_saturated and not_collapsed

def check_condition3(m):
    """
    Condition 3: Cross-term inequality
    """
    p = m.p
    return (p.w_EI * p.w_IE) > (p.w_EE * p.w_II)

def main():
    print("=== Test necessary conditions ===")
    for w_EE in np.arange(5, 25, 2):
        for w_II in np.arange(0, 20, 2):
            para = WilsonCowanParams()
            model = WilsonCowanModel(para)
            for Ie in np.arange(0, 2, 0.5):
                m1 = model.with_para(w_EE=w_EE, w_II=w_II, I_E=Ie)
                result = m1.find_fixed_point()
                if result:
                    for r_E, r_I in result:
                        c1 = check_condition1(m1, r_E, r_I, Ie)
                        c2 = check_condition2(m1, r_E, r_I, Ie)
                        c3 = check_condition3(m1)
                        
                        actual_state = m1.state_system(r_E, r_I)
                        
                        print(f"w_EE={w_EE:2d} w_II={w_II:2d} | I_E={Ie:.2f} | C1:{c1:<5} C2:{c2:<5} C3:{c3:<5} | State: {actual_state}")
                        
                        if actual_state == "Unstable Spiral":
                            assert c1 and c2 and c3, "The theory is wrong"

if __name__ == "__main__":
    main()