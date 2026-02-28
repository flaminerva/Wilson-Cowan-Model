#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: 2.5cm)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")

#align(center)[
  #text(size: 18pt, weight: "bold")[Wilson-Cowan Model]
]

#v(1em)

In #link("https://en.wikipedia.org/wiki/Computational_neuroscience")[computational neuroscience], the *Wilson-Cowan model* (#link("https://en.wikipedia.org/w/index.php?title=H.R._Wilson&action=edit&redlink=1")[Hugh R. Wilson] & #link("https://en.wikipedia.org/wiki/Jack_D._Cowan")[Jack D. Cowan]) describes the dynamics of interactions between populations of very simple excitatory and inhibitory model #link("https://en.wikipedia.org/wiki/Neuron")[neurons]. It is a mean-field model that tracks the *proportion of active neurons* in each population over time.

#figure(
  image("figures/fnsys-16-723237-g001.webp", width: 60%),
  caption: [Schematic of the Wilson-Cowan model#footnote[_E_ represents the excitatory populations, _I_ stands for the inhibitory populations, the red arrows indicate the excitatory projections and blue arrows show the inhibitory projections, $i_I$ is the external inputs of the _I_ populations, and $i_E$ is the external inputs of the _E_ populations. #link("https://doi.org/10.3389/fnsys.2022.723237")[Li et al. (2022)]]],)


$ tau_E (d r_E) / (d t) = -r_E + F_E (w_(E E) dot r_E - w_(E I) dot r_I + I_E^"ext") $

$ tau_I (d r_I) / (d t) = -r_I + F_I (w_(I E) dot r_E - w_(I I) dot r_I + I_I^"ext") $

where the activation function $F$ is a sigmoid:

$ F(x; a, theta) = 1 / (1 + e^(-a(x - theta))) - 1 / (1 + e^(a theta)) $

The correction term $-1 / (1 + e^(a theta))$ ensures $F(0) = 0$ (no input yields no activation).

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  *Remark*: We use the simplified Wilson-Cowan equations without the refractory term $(1 - r_E)$, following the formulation in #link("https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html")[Neuromatch Academy].
]

== Variables

- $r_E (t)$ — average firing rate (or proportion of active neurons) of the *excitatory* population at time $t$. Ranges from 0 (silent) to 1 (maximally active).
- $r_I (t)$ — average firing rate of the *inhibitory* population at time $t$.

== Parameters

=== Time Constants

- $tau_E$ — time constant of the excitatory population.
- $tau_I$ — time constant of the inhibitory population.

=== Sigmoid Parameters

- $a_E$, $a_I$ — gain (steepness) of the activation function for E and I populations. Higher gain means a sharper threshold-like response.
- $theta_E$, $theta_I$ — threshold of the activation function. The input level at which the population reaches half-maximal activation.

=== Connection Weights

- $w_(E E)$ — excitatory → excitatory coupling strength (recurrent excitation).
- $w_(E I)$ — inhibitory → excitatory coupling strength (how much I suppresses E).
- $w_(I E)$ — excitatory → inhibitory coupling strength (how much E drives I).
- $w_(I I)$ — inhibitory → inhibitory coupling strength (recurrent inhibition).

=== External Inputs

- $I_E^"ext"$ — external input current to the excitatory population (primary control parameter for bifurcation analysis).
- $I_I^"ext"$ — external input current to the inhibitory population (typically fixed at 0).

=== Parameter Values

#figure(
  table(
    columns: (auto, auto, 1fr),
    align: (center, center, left),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Parameter*], [*Value*], [*Description*],
    [$tau_E$], [1.0 ms], [Average synaptic time constant for excitatory population],
    [$tau_I$], [2.0 ms], [Average synaptic time constant for inhibitory population],
    [$a_E$], [1.2], [Excitatory gain],
    [$a_I$], [1.0], [Inhibitory gain],
    [$theta_E$], [2.8], [Excitatory threshold],
    [$theta_I$], [4.0], [Inhibitory threshold],
    [$w_(E E)$], [9.0], [Strength of self-excitatory feedback],
    [$w_(E I)$], [4.0], [Strength of connections between E–I],
    [$w_(I E)$], [13.0], [Strength of connections between I–E],
    [$w_(I I)$], [11.0], [Strength of self-inhibitory feedback],
    [$I_E^"ext"$], [0.0], [External input to excitatory population (sweep this)],
    [$I_I^"ext"$], [0.0], [External input to inhibitory population],
  ),
  caption: [Default parameter values from the Neuromatch Academy computational neuroscience curriculum.],
)

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  *Remark*: The parameters play an important role in the system, please read the _Periodic solution (Oscillations)_ part in details.
]

= Nullcline Analysis

== E-nullcline

Let $dot(r)_E = 0$, then

$ 1 / tau_E (-r_E + F_E (w_(E E) dot r_E - w_(E I) dot r_I + I_E^"ext")) = 0 $

$ -r_E + F_E (w_(E E) dot r_E - w_(E I) dot r_I + I_E^"ext") = 0 $

$ F_E (w_(E E) dot r_E - w_(E I) dot r_I + I_E^"ext") = r_E $

Then we use the inverse of $F$ (namely the logit function):

$ F^(-1)(y; a, theta) = theta + 1 / a ln (y + c) / (1 - y - c), quad c = 1 / (1 + e^(a theta)) $

Applying $F_E^(-1)$ to both sides:

$ F_E^(-1)(r_E) = w_(E E) dot r_E - w_(E I) dot r_I + I_E^"ext" $

Solving for $r_I$:

$ r_I = 1 / w_(E I) (w_(E E) dot r_E - F_E^(-1)(r_E) + I_E^"ext") $

== I-nullcline

Analogously, let $dot(r)_I = 0$, we have
$ r_I= F_I (w_(I E) dot r_E - w_(I I) dot r_I + I_I^"ext") $


$ r_E = 1 / w_(I E) (w_(I I) dot r_I + F_I^(-1)(r_I) - I_I^"ext") $


== Phase plane

After substituting the parameters, we obtain the figure

#figure(
  image("figures/phase_plane.png", width: 80%),
  caption: [Phase plane analysis],
)

Inserting point $(0.1, 0.5)$, it's easy to check the arrow direction. We omit here.

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  *Remark:* The domains are $r_E in (0, 0.9664)$ and $r_I in (0, 0.9820)$, as the logarithm requires its argument to be positive.
]

= Qualitative Analysis

Note that in the previous section, we obtain the phase plane with 3 equilibrium points. Now we use the Jacobian matrix to determine its state. Recall the Jacobian matrix:

$ J = mat(
  (partial dot(r)_E) / (partial r_E), (partial dot(r)_E) / (partial r_I);
  (partial dot(r)_I) / (partial r_E), (partial dot(r)_I) / (partial r_I)
) $

We solve the partial derivative and obtain

$ J = mat(
  1 / tau_E (-1 + w_(E E) dot F'_E), 1 / tau_E (-w_(E I) dot F'_E);
  1 / tau_I (w_(I E) dot F'_I), 1 / tau_I (-1 - w_(I I) dot F'_I)
) $

in which

$ F'(x) = a dot (F(x) + c)(1 - F(x) - c), quad c = 1 / (1 + e^(a theta)) $

Note that $F'$ is evaluated at the sigmoid input, not at $r_E$ or $r_I$ directly:

$ u_E = w_(E E) r_E - w_(E I) r_I + I_E^"ext", quad u_I = w_(I E) r_E - w_(I I) r_I + I_I^"ext" $

We classify each fixed point using the trace $tau = tr(J)$, determinant $Delta = det(J)$, and discriminant $tau^2 - 4 Delta$ of the Jacobian:

- $Delta < 0 arrow.double$ saddle point
- $Delta > 0, tau < 0 arrow.double$ stable (node if $tau^2 - 4 Delta > 0$, spiral if $< 0$)
- $Delta > 0, tau > 0 arrow.double$ unstable

For our 3 fixed points:

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Fixed Point*], [$tau$], [$Delta$], [$tau^2 - 4Delta$], [*Classification*],
    [$(0, 0)$], [$-1.247$], [$0.406$], [$-0.069$], [Stable Spiral],
    [$(approx 0.34, 0.17)$], [—], [$-0.941$], [—], [Saddle Point],
    [$(approx 0.94, 0.68)$], [$-2.403$], [$1.381$], [$0.250$], [Stable Node],
  ),
  caption: [Fixed point classification for default parameters ($I_E^"ext" = 0$).],
)

#v(0.5em)

The system with default parameters ($I_E^"ext" = 0$) is therefore *bistable*. (In a #link("https://en.wikipedia.org/wiki/Dynamical_system")[dynamical system], *bistability* means the system has two #link("https://en.wikipedia.org/wiki/Stability_theory")[stable equilibrium states]; a bistable structure can be resting in either of two states.)

= Periodic Solutions (Oscillations)

Recall the *Poincaré-Bendixson theorem* states that for a two-dimensional system, for which we know that the solutions will stay in *a bounded area* after some finite time and there is *no fixed point*, there must exist a periodic solution to which the trajectories converge.

We sweep the $I_E^"ext"$ until we obtain only one fixed point which is unstable.

#figure(
  image("figures/nma.png", width: 60%),
  caption: [Stable fixed point output after sweeping $I_E^"ext"$],
)

Note that after sweeping $I_E^"ext"$, we only get the stable 1 fixed point, why?

#v(1em)

Comparing with the parameters used in #link("https://doi.org/10.3389/fnsys.2022.723237")[Li et al. (2022)] (Table 1, based on #link("https://doi.org/10.1016/S0006-3495(72)86068-5")[Wilson and Cowan (1972)] and #link("https://doi.org/10.1109/JPROC.2014.2313113")[Jadi and Sejnowski (2014)]) for gamma oscillation research:

#figure(
  table(
    columns: (1fr, auto, auto),
    align: (left, center, center),
    stroke: 0.5pt + gray,
    inset: 8pt,
    [*Parameter*], [*NMA (bistability)*], [*Table 1 (oscillation)*],
    [$w_(E E)$], [9], [16],
    [$w_(E I)$], [4], [26],
    [$w_(I E)$], [13], [20],
    [$w_(I I)$], [11], [1],
    [$tau_E$ (ms)], [1], [20],
    [$tau_I$ (ms)], [2], [10],
    [$theta_E, theta_I$], [2.8, 4.0], [5, 20],
    [$I_E^"ext", I_I^"ext"$], [0, 0], [2, 7],
  ),
  caption: [Parameter comparison: bistable vs. oscillatory regime.],
)

#figure(
  image("figures/fixed_points.png", width: 80%),
  caption: [Output comparison between NMA (bistable) and Li et al. (oscillatory) parameter regimes.],
)


#figure(
  image("figures/parameter_space_v2.png", width: 60%),
  caption: [Oscillatory regime in (Wee, WI) parameter space for NMA parameters],
)



== Conditions for Oscillation

A Hopf bifurcation requires a fixed point where the Jacobian has both positive trace (instability) and positive determinant (complex eigenvalues):

$ tau = 1/tau_E (-1 + w_(E E) F'_E) + 1/tau_I (-1 - w_(I I) F'_I) $

$ Delta = 1/(tau_E tau_I) [1 + w_(I I) F'_I - w_(E E) F'_E + (w_(E I) w_(I E) - w_(E E) w_(I I)) F'_E F'_I] $

The trace condition $tau > 0$ requires $w_(E E) F'_E$ to be large: excitatory recurrence must overcome intrinsic decay. In the determinant, $w_(E E) F'_E$ appears in two terms: $-w_(E E) F'_E$ (which pushes $Delta$ down) and the cross-term $(w_(E I) w_(I E) - w_(E E) w_(I I)) F'_E F'_I$. The sign of $w_(E I) w_(I E) - w_(E E) w_(I I)$ determines whether the two conditions cooperate or compete.

This yields three *necessary*#footnote[Here we mean necessary condition since it's *not sufficient*. It is crucial to note that while no oscillatory state (Unstable Spiral) can violate these conditions, satisfying them is necessary but not sufficient for a Hopf bifurcation. Even when Condition 2 holds, the positive cross-term $(w_(E I)w_(I E) - w_(E E)w_(I I))F'_E F'_I'$ must be large enough to overcome the negative trace-related term $-w_(E E)F'_E$ and keep the entire determinant $Delta > 0$. If this cooperative "pull" is insufficient, the determinant drops below zero ($Delta < 0$), and the system inevitably collapses into a Saddle Point, despite satisfying all three necessary conditions.] conditions for oscillation:

*Condition 1*: $w_(E E) F'_E$ must be large enough that the excitatory term overcomes intrinsic decay $w_(E E) F'_E > tau_E (1 + 1/tau_I (1 + w_(I I) F'_I))$.

*Condition 2*: $w_(E I) w_(I E) > w_(E E) w_(I I)$. When this holds, increasing $F'_E$ pushes the trace up and helps the determinant stay positive, which means that the two Hopf conditions are cooperative. When violated, increasing $F'_E$ raises the trace but drags the determinant down: no fixed point can satisfy both conditions simultaneously.

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  *Remark:* What if $w_(E I) w_(I E) = w_(E E) w_(I I)$? Let us assume $w_(E I) w_(I E) = w_(E E) w_(I I)$. Then$ Delta = 1/(tau_E tau_I) (1 + w_(I I) F'_I - w_(E E) F'_E ) $ For $ Delta > 0$, we need $1 + w_(I I) F'_I> w_(E E) F'_E $. For $tau > 0$, $w_(E E)F'_E > 1 + tau_E/tau_I (1 + w_(I I)F'_I)$. Thus for both hold simultaneously, we need $1+ w_(I I) F'_I>w_(E E)F'_E > 1 + tau_E/tau_I (1 + w_(I I)F'_I)$. Note that it may hold when $tau_E/tau_I<1$, i.e. $tau_E< tau_I$. \
  From Keeley et al. (2019),
  "weakly modulated network gamma is found when the firing rate of the inhibitory population is recruited faster than that of the excitatory population, and strongly synchronized gamma oscillations are seen for the reverse. In both frameworks, network oscillations arise when a steady state loses stability via Hopf bifurcation as drive to the excitatory population increases. The small-amplitude oscillation that emerges from the bifurcation persists over a substantial range of values of the drive in the weakly modulated regime, but for the strongly synchronous case the oscillation amplitude rises sharply to become a strongly synchronous E-I rhythm as drive increases".\
  It shows that the Oscillation may occur when $tau_E< tau_I$ and $w_(E I) w_(I E) = w_(E E) w_(I I)$. But since it is not Gamma oscillation, we don't count the equality. And it implies that $1 + w_(I I) F'_I <= w_(E E) F'_E $, so we need $w_(E I) w_(I E) - w_(E E) w_(I I)>0$ to keep the $Delta>0$.]


*Condition 3*: $w_(E E)$ must lie in a finite window. The sigmoid derivative $F'_E$ is maximised when $u_E = w_(E E) r_E - w_(E I) r_I + I_E^"ext"$ lies near the midpoint $theta_E$. If $w_(E E)$ is too small, $u_E$ stays below $theta_E$ and $F'_E$ is small. If $w_(E E)$ is too large, strong positive feedback pushes the fixed point past $theta_E$ into saturation, and $F'_E$ is again small. Only intermediate $w_(E E)$ places the fixed point in the steep region of the sigmoid.

=== Verification#footnote[To verify it, use our condition test module.]\
Numerical evaluation at selected points in the $(w_(E E), w_(I I))$ parameter space confirms all three conditions. At oscillatory points (e.g. $w_(E E) = 6$, $w_(I I) = 1$), the system has a single Unstable Spiral with $u_E = 2.27$ (near $theta_E = 2.8$), $F'_E = 0.27$ (near the maximum $a_E\/4 = 0.3$), and a positive cross-term of $w_(E I) w_(I E) - w_(E E) w_(I I) = 46$. All three conditions are satisfied.

Points that violate individual conditions fail to oscillate:
- $(w_(E E) = 10.5, w_(I I) = 5.0)$: cross-term $approx 0$ — condition 2 fails at the boundary.
- $(w_(E E) = 12, w_(I I) = 1)$: cross-term $= 40 > 0$, but $w_(E E)$ too large pushes the fixed point past $theta_E$ into saturation — condition 3 fails.
- $(w_(E E) = 10, w_(I I) = 3)$: cross-term $= 22 > 0$, but $w_(E E) F'_E$ insufficient — condition 1 fails.

All observed oscillations occur through Hopf bifurcation at a single fixed point (Unstable Spiral). No oscillation via the global three-fixed-point mechanism (two Unstable Spirals + Saddle) was found in the parameter range surveyed.

=== Application to the parameters

For the NMA default parameters ($w_(E E) = 9$, $w_(E I) = 4$, $w_(I E) = 13$, $w_(I I) = 11$):

$ w_(E I) w_(I E) = 52 < 99 = w_(E E) w_(I I) $

Condition 2 is violated: the cross-term is $-47 F'_E F'_I$, strongly competitive. The trace and determinant conditions cannot be simultaneously satisfied at any fixed point. Numerically, the saddle point achieves $F'_E$ up to $0.28$ with positive trace, but $Delta < 0$; the stable spiral has $Delta > 0$, but $F'_E lt.eq 0.12$ and negative trace. No Hopf bifurcation occurs regardless of $I_E^"ext"$.

For Li et al. ($w_(E E) = 16$, $w_(E I) = 26$, $w_(I E) = 20$, 
$w_(I I) = 1$, $theta_E = 5.0$): $w_(E I) w_(I E) = 520 >> 16 
= w_(E E) w_(I I)$ (condition 2), $u_E = 5.24 approx theta_E = 5.0$ 
(condition 3), and $w_(E E) F'_E = 4.7$ (condition 1). All three 
conditions are satisfied, and the system exhibits a Hopf bifurcation 
at a single Unstable Spiral.

=== Further discussion
Our analytical conditions are consistent with the numerical bifurcation results of Li et al. (2022), who investigated the role of self-feedback loops in regulating gamma oscillations in the Wilson-Cowan model. Their one-parameter bifurcation with respect to $w_(I I)$ (their Figure 3A) shows that increasing inhibitory self-feedback suppresses oscillation, which directly follows from our Condition 2: since $w_(E I) w_(I E)$ is fixed, increasing $w_(I I)$ raises $w_(E E) w_(I I)$ and eventually violates the cross-term inequality.\
For excitatory self-feedback, their one-parameter bifurcation with respect to $w_(E E)$ (their Figure 6A) reveals that oscillation exists only within a finite window $13.57 < w_(E E) < 35$, confirming our Condition 3. However, their summary conclusion that "excitatory self-feedback promotes the generation of gamma oscillations" captures only the lower boundary of this window. Our analysis clarifies why both boundaries exist: the lower bound reflects Condition 1 (insufficient excitatory gain to destabilize the fixed point), while the upper bound reflects Condition 3 (excessive recurrence drives the fixed point past the sigmoid's sensitive region into saturation, reducing $F'_E$). Their transfer function analysis (their Eq. 13–14) assumes $w_(E E) K_E < 1$, which corresponds precisely to the interior of this window.

#v(1em)

We refer to the following papers:

*Inhibitory self-feedback.* #link("https://doi.org/10.3389/fnsys.2022.723237")[Li et al. (2022)]:

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  The present results reveal that, on one hand, the inhibitory self-feedback loop is not conducive to the generation of gamma oscillations, and increased inhibitory self-feedback strength facilitates the enhancement of the oscillation frequency. On the other hand, the excitatory self-feedback loop promotes the generation of gamma oscillations \[...\] Inhibitory and excitatory self-feedback loops play a complementary role in generating and regulating the gamma oscillation in Wilson-Cowan model.
]
*Time constants.* #link("https://doi.org/10.1152/jn.00741.2018")[Keeley et al. (2019)]:

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  The models' flexibility to capture the broad range of gamma behavior depends directly on the timescales that represent recruitment of the excitatory and inhibitory firing rates. In particular, we find that weakly modulated gamma oscillations occur robustly when the recruitment timescale of inhibition is faster than that of excitation.
]


#v(2em)

= Key References

+ *Wilson, H.R. & Cowan, J.D. (1972).* Excitatory and inhibitory interactions in localized populations of model neurons. _Biophysical Journal_, 12(1), 1–24. doi: #link("https://doi.org/10.1016/S0006-3495(72)86068-5")[10.1016/S0006-3495(72)86068-5]

+ *Wilson, H.R. & Cowan, J.D. (1973).* A mathematical theory of the functional dynamics of cortical and thalamic nervous tissue. _Kybernetik_, 13(2), 55–80. doi: #link("https://doi.org/10.1007/BF00288786")[10.1007/BF00288786]

+ *Destexhe, A. & Sejnowski, T.J. (2009).* The Wilson-Cowan model, 36 years later. _Biological Cybernetics_, 101(1), 1–2. doi: #link("https://doi.org/10.1007/s00422-009-0328-3")[10.1007/s00422-009-0328-3]

+ *Jadi, M.P. & Sejnowski, T.J. (2014).* Regulating cortical oscillations in an inhibition-stabilized network. _Proceedings of the IEEE_, 102(5), 830–842. doi: #link("https://doi.org/10.1109/JPROC.2014.2313113")[10.1109/JPROC.2014.2313113]

+ *Keeley, S., Byrne, Á., Fenton, A. & Rinzel, J. (2019).* Firing rate models for gamma oscillations. _Journal of Neurophysiology_, 121(6), 2181–2190. doi: #link("https://doi.org/10.1152/jn.00741.2018")[10.1152/jn.00741.2018]

+ *Li, D., Liu, S. & Wang, J. (2022).* Bidirectionally regulating gamma oscillations in Wilson-Cowan model by self-feedback loops: a computational study. _Frontiers in Systems Neuroscience_, 16, 723237. doi: #link("https://doi.org/10.3389/fnsys.2022.723237")[10.3389/fnsys.2022.723237]

+ *#link("https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html")[Neuromatch Academy — Computational Neuroscience, W2D4: Dynamic Networks]*
