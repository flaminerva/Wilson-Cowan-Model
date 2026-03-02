# Conditions for Oscillation in the Wilson-Cowan Model

Analytical conditions for Hopf bifurcation in the Wilson-Cowan
neural population model, with application to the Neuromatch Academy
(NMA) and Li et al. (2022) parameter sets.

## Summary

We derive a **structural necessary condition** for oscillation:

$$w_{EI}w_{IE} > \frac{16\,\tau_E\,w_{II}}{\tau_I\,a_E}$$

This single inequality determines whether oscillation is possible
regardless of external input or fixed-point tuning. The NMA
parameters violate it ($52 < 73.3$); the Li et al. parameters
satisfy it with wide margin ($520 \gg 32$).

We develop a **three-level verification framework**:
1. **Structural** — can the network support oscillation at all?
2. **Window existence** — does a feasibility window remain open
   at the realised fixed point?
3. **Operating point in window** — does the actual $w_{EE}F'_E$
   fall between the trace lower bound and the determinant upper
   bound?

By coupling the sigmoid derivatives along the I-nullcline, we
tighten the structural bound and show the decoupled optimum is
an exact special case of the coupled problem. An **I-nullcline
sweep algorithm** identifies, for each parameter set, whether
any external input produces a unique unstable fixed point.

Two independent **Monte Carlo validations** ($N = 5000$ each)
confirm 0 genuine theoretical violations. The I-nullcline sweep
establishes the essential dynamical divide: unique unstable
fixed point → **97.8%** oscillation versus **0.3%** for
multi-fixed-point systems. The three-level framework with
random external input yields consistent results (89.7% vs
6.2%), with the difference attributable to the sweep selecting
the most favourable input.

See the [full report (PDF)](docs/WC_report.pdf) for derivations,
verification, and comparison with Li et al. (2022).

## Key references

- Li, Liu & Wang (2022). *Bidirectionally regulating gamma
  oscillations in Wilson-Cowan model by self-feedback loops.*
  Frontiers in Systems Neuroscience, 16, 723237.
- Keeley, Byrne, Fenton & Rinzel (2019). *Firing rate models for
  gamma oscillations.* Journal of Neurophysiology, 121(6),
  2181–2190.
- Neuromatch Academy — Computational Neuroscience, W2D4: Dynamic
  Networks.

## What in the future
We are writing a C# version for visualization and interaction, and a Julia version for fun (purely because of aesthetic preferences).
And please note that I haven't submitted the algo (the test is the old version), I will refactory it in julia.
