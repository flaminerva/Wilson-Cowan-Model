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

A **Monte Carlo validation** ($N = 5000$) confirms 0 genuine
theoretical violations across the entire framework. The full
sufficient condition for a limit cycle is Level 3 satisfied at
the system's **unique** fixed point (~90% confirmation rate; the
gap from 100% is attributable to numerical detection limits).
Multi-fixed-point systems show no confirmed limit cycles despite
passing Level 3; all such cases are consistent with transient
oscillations near an unstable spiral that are eventually captured
by a competing stable attractor.

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
