## Wilson-Cowan Model

Please check the [report (PDF)](docs/WC_report.pdf) to see the full theoretical analysis.

Qualitative analysis of the Wilson-Cowan neural population model, comparing bistable (Neuromatch Academy) and oscillatory (Li et al., 2022) parameter regimes.

## What we‘ve done
- **Nullcline and phase plane analysis** for both parameter sets
- **Fixed point classification** via Jacobian eigenvalues (stable node/spiral, saddle, unstable spiral)
- **Parameter space scan** of oscillatory regime in ($w_{EE}$, $w_{II}$) plane
- **Conditions of ossscillation**\
In the Wilson-Cowan model, the product of the E-I cross-coupling weights must exceed the product of the self-feedback weights for (gamma) oscillations to be possible; even then, the excitatory weight must fall within a finite window to keep the fixed point in the sensitive region of the sigmoid function.\
(This is the most important conclusion in the report.)

## What in the future
We are writing a C# version for visualization and interaction, and a Julia version for fun (purely because of aesthetic preferences).
