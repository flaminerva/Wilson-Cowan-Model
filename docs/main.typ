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


== Why the NMA Parameters Prevent Oscillations

For a Hopf bifurcation to occur, the Jacobian trace must cross zero from below. Expanding the trace with the default parameters ($tau_E = 1$, $tau_I = 2$):

$ tau = 1/tau_E (-1 + w_(E E) F'_E) + 1/tau_I (-1 - w_(I I) F'_I) = -1.5 + 9 F'_E - 5.5 F'_I $

The condition $tau > 0$ requires:

$ 9 F'_E > 1.5 + 5.5 F'_I $

At first glance, the coefficient 9 on $F'_E$ exceeds 5.5 on $F'_I$, suggesting that the destabilizing excitatory term could dominate. However, the weights $w_(E E)$ and $w_(I I)$ play a _dual role_: they appear both as coefficients in the trace and inside the sigmoid inputs that determine $F'_E$ and $F'_I$ themselves.

The sigmoid inputs at a fixed point $(r_E, r_I)$ are:

$ u_E = 9 r_E - 4 r_I, quad u_I = 13 r_E - 11 r_I $

This creates two mechanisms that jointly prevent $tau > 0$:

*Mechanism 1: $F'_E$ is bounded.* The maximum of $F'$ occurs at the sigmoid midpoint and equals $a\/4$. For $a_E = 1.2$, this gives $F'_E <= 0.3$, so $9 F'_E <= 2.7$. The condition $tau > 0$ then requires $5.5 F'_I < 1.2$, i.e. $F'_I < 0.22$. This is a tight constraint.

*Mechanism 2: $w_(I I)$ controls the operating point of $F'_I$.* In $u_I = 13 r_E - 11 r_I$, the large coefficient $w_(I I) = 11$ pulls $u_I$ downward as $r_I$ increases. But at any fixed point, the condition $r_I = F_I (u_I)$ constrains $u_I$ to a region where $F'_I$ remains non-negligible. Specifically, at the lower fixed points (before the saddle-node bifurcation), $u_I$ stays close enough to the sigmoid's active region that $F'_I > 0.22$, which is sufficient for $5.5 F'_I$ to block the condition $tau > 0$.

After the saddle-node bifurcation, only the upper fixed point ($r_E approx 0.95$) remains. Here $u_E$ is deep in the sigmoid saturation region, so $F'_E approx 0$, and the trace simplifies to $tau approx -1.5 - 5.5 F'_I$, which is unconditionally negative.

Thus $w_(I I)$ suppresses oscillations in two distinct ways: it amplifies the stabilizing $-5.5 F'_I$ term in the trace, and it simultaneously shapes the sigmoid operating point to keep $F'_I$ large enough that this term dominates. This double effect explains why simply sweeping $I_E^"ext"$ cannot produce a Hopf bifurcation under the NMA parameters.


The NMA parameters are designed to demonstrate *bistability* (working memory), not oscillations. Comparing with the parameters used in #link("https://doi.org/10.3389/fnsys.2022.723237")[Li et al. (2022)] (Table 1, based on #link("https://doi.org/10.1016/S0006-3495(72)86068-5")[Wilson and Cowan (1972)] and #link("https://doi.org/10.1109/JPROC.2014.2313113")[Jadi and Sejnowski (2014)]) for gamma oscillation research:

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
  image("figures/parameter_space.png", width: 60%),
  caption: [Oscillatory regime in (Wee, WI) parameter space],
)

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[*Remark*: Note that around $w_(E E) approx 11.5$, $w_(I I) approx 8.7$, there is a non-monotonic protrusion in the oscillatory boundary: the maximum tolerable $w_(I I)$ for oscillations peaks sharply before settling to $approx 5$ for larger $w_(E E)$.]

Regarding the influence of parameters, we refer to the following papers rather than reproducing their analysis:

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

#figure(
  image("figures/fixed_points.png", width: 80%),
  caption: [Output comparison between NMA (bistable) and Li et al. (oscillatory) parameter regimes.],
)

#v(2em)

= Key References

+ *Wilson, H.R. & Cowan, J.D. (1972).* Excitatory and inhibitory interactions in localized populations of model neurons. _Biophysical Journal_, 12(1), 1–24. doi: #link("https://doi.org/10.1016/S0006-3495(72)86068-5")[10.1016/S0006-3495(72)86068-5]

+ *Wilson, H.R. & Cowan, J.D. (1973).* A mathematical theory of the functional dynamics of cortical and thalamic nervous tissue. _Kybernetik_, 13(2), 55–80. doi: #link("https://doi.org/10.1007/BF00288786")[10.1007/BF00288786]

+ *Destexhe, A. & Sejnowski, T.J. (2009).* The Wilson-Cowan model, 36 years later. _Biological Cybernetics_, 101(1), 1–2. doi: #link("https://doi.org/10.1007/s00422-009-0328-3")[10.1007/s00422-009-0328-3]

+ *Jadi, M.P. & Sejnowski, T.J. (2014).* Regulating cortical oscillations in an inhibition-stabilized network. _Proceedings of the IEEE_, 102(5), 830–842. doi: #link("https://doi.org/10.1109/JPROC.2014.2313113")[10.1109/JPROC.2014.2313113]

+ *Keeley, S., Byrne, Á., Fenton, A. & Rinzel, J. (2019).* Firing rate models for gamma oscillations. _Journal of Neurophysiology_, 121(6), 2181–2190. doi: #link("https://doi.org/10.1152/jn.00741.2018")[10.1152/jn.00741.2018]

+ *Li, D., Liu, S. & Wang, J. (2022).* Bidirectionally regulating gamma oscillations in Wilson-Cowan model by self-feedback loops: a computational study. _Frontiers in Systems Neuroscience_, 16, 723237. doi: #link("https://doi.org/10.3389/fnsys.2022.723237")[10.3389/fnsys.2022.723237]

+ *#link("https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html")[Neuromatch Academy — Computational Neuroscience, W2D4: Dynamic Networks]*
