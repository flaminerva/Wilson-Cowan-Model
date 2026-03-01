#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: 2.5cm)
#set heading(numbering: "1.1")
#set math.equation(numbering: "(1)")



#align(center)[
  #text(size: 18pt, weight: "bold")[Conditions for Oscillation in the Wilson-Cowan Model]
]

#align(center)[
  #text(size: 0.9em, style: "italic")[
    *Abstract.* We investigate why the Neuromatch Academy (NMA)
    default parameters for the Wilson-Cowan model cannot produce
    oscillations under any external input. Starting from the Hopf
    bifurcation requirements on the Jacobian trace and determinant,
    we derive a structural necessary condition on the network
    parameters: $w_(E I)w_(I E) > 16 tau_E w_(I I) slash
    (tau_I a_E)$. This single inequality, involving only coupling
    weights, time constants, and sigmoid gain, determines whether
    oscillation is possible regardless of external input or
    fixed-point tuning. The NMA parameters violate this condition
    ($52 < 73.3$), while the oscillatory parameters of Li et
    al.~(2022) satisfy it with wide margin ($520 >> 32$). We
    further develop a three-level verification framework —
    structural feasibility, window existence at realised fixed
    points, and actual operating point within the window — and
    validate it with a Monte Carlo study ($N = 5000$). The structural condition is confirmed as a strict necessary condition, with zero genuine theoretical violations across the entire framework in 5000 samples, while the full sufficient
    condition requires the unstable fixed point to be the
    system's unique equilibrium. Applying this framework to the
    Li et al. analysis, we show that excitatory self-feedback
    $w_(E E)$ acts as a tuning parameter with a finite effective
    range, clarifying the bounded oscillation window observed in
    their numerical bifurcation results.
  ]
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

$ F'(x) = a dot (F(x) + c)(1 - F(x) - c), quad c = 1 / (1 + e^(a theta)) $<eq:sigmoid-deriv>

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

The answer lies in the network's structural parameters. 
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

- $tau>0$: 
  In order to let $1/tau_E (-1 + w_(E E) F'_E) + 1/tau_I (-1 -
  w_(I I) F'_I)>0$, we need 
  $
  w_(E E) F'_E > 1 + tau_E/tau_I (1 + w_(I I) F'_I) 
  $<eq:trace_bound>

- $Delta>0$: In order to let 
  $
  1/(tau_E tau_I) [1 + w_(I I) F'_I - w_(E E) F'_E + (w_(E I)
  w_(I E) - w_(E E) w_(I I)) F'_E F'_I] > 0
  $
  we require 
  $
  1 + w_(I I)F'_I + w_(E I)w_(I E)F'_E F'_I > w_(E E)F'_E +
  w_(E E)w_(I I)F'_E F'_I
  $
  $
  1 + w_(I I)F'_I + w_(E I)w_(I E)F'_E F'_I > w_(E E)F'_E
  (1 + w_(I I)F'_I)
  $<eq:det_bound>
  Rearranging as an upper bound on $w_(E E)F'_E$:
  $
  w_(E E)F'_E < (1 + w_(I I)F'_I + w_(E I)w_(I E)F'_E F'_I)
  / (1 + w_(I I)F'_I)
  $<eq:det_upper>

Combining @eq:trace_bound and @eq:det_upper, a feasibility window
for $w_(E E)F'_E$ exists only when the lower bound is less than
the upper bound:

$ 1 + tau_E/tau_I (1 + w_(I I)F'_I)<
  (1 + w_(I I)F'_I + w_(E I)w_(I E)F'_E F'_I)
  / (1 + w_(I I)F'_I) $

Multiplying both sides by $(1 + w_(I I)F'_I)$ and simplifying:

$ w_(E I)w_(I E) > tau_E/tau_I dot
  (1 + w_(I I)F'_I)^2 / (F'_E F'_I) $<eq:master>


Since $F'_E$ and $F'_I$ are not free parameters but determined by
the fixed point, we minimise the right-hand side to obtain the
weakest necessary condition.

*Maximising $F'_E$.* $F'_E$ appears only in the denominator, so
we need its maximum. From @eq:sigmoid-deriv:
$ F'(x) = a dot (F(x) + c)(1 - F(x) - c) $
This is maximised when $F(x) + c = 1 slash 2$, i.e.~at the
sigmoid midpoint $u_E = theta_E$. Substituting:
$ F'^"max"_E = a_E dot 1 / 2 dot 1 / 2 = a_E / 4 $

*Minimising over $F'_I$.* Let $phi = F'_I > 0$. The right-hand
side of @eq:master becomes:
$ R(phi) = tau_E / tau_I dot
  (1 + w_(I I) phi)^2 / ((a_E slash 4) dot phi)
  = (4 tau_E) / (tau_I a_E) dot
  (1 + 2 w_(I I) phi + w_(I I)^2 phi^2) / phi $
Expanding:
$ R(phi) = (4 tau_E) / (tau_I a_E) (
  1 / phi + 2 w_(I I) + w_(I I)^2 phi) $
Differentiating and setting to zero:
$ R'(phi) = (4 tau_E) / (tau_I a_E) (
  -1 / phi^2 + w_(I I)^2) = 0 $
$ phi^2 = 1 / w_(I I)^2 quad ==> quad
  phi^* = 1 / w_(I I) $
To confirm this is a minimum:
$ R''(phi) = (4 tau_E) / (tau_I a_E) dot
  2 / phi^3 > 0 quad "for all" phi > 0 $

Substituting $F'_E = a_E slash 4$ and $F'_I = 1 slash w_(I I)$:
$ R(phi^*) = (4 tau_E) / (tau_I a_E) (
  w_(I I) + 2 w_(I I) + w_(I I))
  = (4 tau_E) / (tau_I a_E) dot 4 w_(I I)
  = (16 tau_E w_(I I)) / (tau_I a_E) $

This yields the structural necessary condition:
$ w_(E I) w_(I E) > (16 tau_E w_(I I)) / (tau_I a_E) $ <eq:structural>


Due to the $F'_E$ and $F'_I$ are jointly determined by the
fixed-point coordinates, they cannot in general simultaneously
attain their optimal values. This makes @eq:structural a
potentially loose bound: a gap quantified by the three-level
framework in the section 3.1.1.

This is a purely structural necessary condition: if it fails, no
fixed point can undergo Hopf bifurcation regardless of where it sits
on the sigmoid. We verify against both parameter sets:

- *Li et al.*: $(16 times 20 times 1) / (10 times 1) = 32$, and
  $w_(E I)w_(I E) = 520 >> 32$. #h(1em) $checkmark$
- *NMA*: $(16 times 1 times 11) / (2 times 1.2) = 73.3$, and
  $w_(E I)w_(I E) = 52 < 73.3$. #h(1em) $times$

The role of each parameter in @eq:master is:

- $w_(E I)w_(I E)$ (left-hand side): the cross-population coupling
  is the sole resource available to meet the cost. It represents
  the strength of the $E -> I -> E$ feedback loop.

- $tau_E\/tau_I$: the time-constant ratio sets the baseline cost.
  When $tau_E > tau_I$ (inhibition recruited faster, the "weakly
  modulated" regime of Keeley et al. (2019)), the cost is higher.

- $(1 + w_(I I)F'_I)^2$: inhibitory self-feedback raises the cost
  quadratically.

- $F'_E$ (denominator only): the excitatory population must operate
  near its sensitive region ($u_E approx theta_E$) to maximise
  $F'_E$ and keep the cost manageable.

- $F'_I$ (both numerator and denominator): increasing $F'_I$ lowers
  the cost through the denominator but raises it through
  $(1 + w_(I I)F'_I)^2$ in the numerator. The optimal balance is
  at $F'_I = 1\/w_(I I)$.

#block(
  fill: rgb("#f0f0f0"),
  inset: 12pt,
  radius: 4pt,
  width: 100%,
)[
  From Keeley et al. (2019): "...weakly modulated network gamma is
  found when the firing rate of the inhibitory population is recruited
  faster than that of the excitatory population, and strongly
  synchronized gamma oscillations are seen for the reverse. In both
  frameworks, network oscillations arise when a steady state loses
  stability via Hopf bifurcation..."]

An immediate corollary concerns the cross-term $w_(E I)w_(I E)$ vs
$w_(E E)w_(I I)$. When $tau_E > tau_I$, assume
$w_(E I)w_(I E) <= w_(E E)w_(I I)$. Then @eq:det_bound requires
$1 + w_(I I)F'_I > w_(E E)F'_E$. Combined with @eq:trace_bound:

$ 1 + w_(I I)F'_I > 1 + tau_E/tau_I (1 + w_(I I)F'_I) $

Dividing by $(1 + w_(I I)F'_I) > 0$ gives $tau_E < tau_I$, a
contradiction. Therefore, in the weakly modulated regime,
$w_(E I)w_(I E) > w_(E E)w_(I I)$ is strictly necessary.



=== From necessity to sufficiency

The structural condition assumes both sigmoid derivatives
simultaneously take their most favourable values. In practice,
the fixed-point position determines the actual $F'_E$ and $F'_I$,
and the full master inequality (@eq:master) must be satisfied at
a realised fixed point. This introduces two additional requirements:


- *Trace bound* ($tau > 0$): $w_(E E)F'_E$ must exceed the
  threshold in @eq:trace_bound. This requires $w_(E E)$ to be
  large enough to place $u_E$ near $theta_E$, keeping $F'_E$
  near its maximum. But if $w_(E E)$ is too large, saturation
  collapses $F'_E$ and the trace condition fails from the other
  direction. The trace thus imposes both a lower and an upper
  bound on $w_(E E)$ through the behaviour of $F'_E$.

- *Determinant upper bound* ($Delta > 0$): independently,
  $w_(E E)F'_E$ must not exceed the algebraic ceiling in
  @eq:det_upper. This bound can be violated even when $F'_E$
  is still large enough for $tau > 0$ — the determinant turns
  negative while the trace remains positive, producing a Saddle.



Together with the structural condition, these requirements fully
characterise the oscillatory regime at three levels:

+ *Structural* (@eq:structural): can the network support
  oscillation at all? A necessary condition on coupling weights
  and time constants alone.

+ *Window exists* (@eq:master at realised fixed point): does the
  feasibility window $L < U$ remain open at the actual sigmoid
  slopes? Necessary but not sufficient.

+ *Fixed point in window* ($L < w_(E E)F'_E < U$): does the
   actual $w_(E E)F'_E$ fall between the trace lower bound and
   the determinant upper bound? This guarantees the fixed point
   is an unstable spiral (local Hopf condition). *A limit cycle
   additionally requires that no other stable attractor captures
   the trajectories*, which is satisfied when this is the
   system's only fixed point#footnote[We discussed about it in section 3.2.3.].


== Verification#footnote[To verify it, use our condition test module.]



=== Structural necessary condition

We first check @eq:structural against both parameter sets:

#figure(
  align(center)[
    #table(
      columns: (2fr, 1fr, 1fr),
      align: (left, center, center),
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.hline(y: 1, stroke: 0.5pt),
      [], [*NMA*], [*Li et al.*],
      [$w_(E I)w_(I E)$], [52], [520],
      [$(16 tau_E w_(I I))/(tau_I a_E)$], [73.3], [32],
      [*Result*],
      [$52 < 73.3$ #h(2pt) $times$],
      [$520 >> 32$ #h(2pt) $checkmark$],
      table.hline(stroke: 1pt)
    )
  ],
  caption: [Structural necessary condition (@eq:structural). NMA
  fails even under the most favourable sigmoid slopes, ruling out
  Hopf bifurcation for any $w_(E E)$ or $I_E^"ext"$.],
)

For Li et al., the condition is satisfied with wide margin, and the
system indeed oscillates at the default parameters ($u_E = 5.24
approx theta_E = 5.0$, confirming that $w_(E E)$ is tuned to keep
$F'_E$ near its maximum).


=== Fixed points
We verify across the $(w_(E E), w_(I I))$ parameter space using
NMA cross-coupling values ($w_(E I) = 4$, $w_(I E) = 13$):

#figure(
  align(center)[
    #table(
      columns: (0.8fr, 0.8fr, 0.8fr, 1.2fr, 1.2fr, 1.2fr, 2.5fr),
      align: (center, center, center, center, center, center, left),
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.hline(y: 1, stroke: 0.5pt),
      [*$w_(E E)$*], [*$w_(I I)$*], [*$I_E^"ext"$*],
      [*Structural*], [*Window*], [*In window*],
      [*Observed behaviour*],

      [11], [0], [0.50],
      [$checkmark$], [$checkmark$], [$checkmark$],
      [*Unstable Spiral* (oscillation)],

      [11], [1], [0.50],
      [$checkmark$], [$checkmark$], [$checkmark$],
      [*Unstable Node* (oscillation)],

      [11], [5], [0.00],
      [$checkmark$], [$times$], [$times$],
      [Stable Spiral + Saddle + Stable Node],

      [14], [2], [0.00],
      [$checkmark$], [$checkmark$], [$times$],
      [Stable Spiral + Saddle],

      [20], [0], [0.00],
      [$checkmark$], [$times$], [$times$],
      [Stable Node + Saddle],

      [9], [11], [0.00],
      [$times$], [$times$], [$times$],
      [Stable Spiral + Saddle + Stable Node],

      table.hline(stroke: 1pt)
    )
  ],
  caption: [Three-level verification of oscillation conditions.
  #footnote[*Structural*: @eq:structural satisfied.\      *Window*: feasibility
  window $L < U$ exists at the realised fixed point (@eq:master).\
  *In window*: actual $w_(E E)F'_E$ falls between trace lower
  bound and determinant upper bound.\
  Oscillation requires all
  three.]],
)

Each failure mode corresponds to a different level:

- $(w_(E E) = 9, w_(I I) = 11)$ (NMA defaults): fails at level 1.
  The structural condition gives $52 < 73.3$, ruling out oscillation
  regardless of $w_(E E)$ tuning or external input.

- $(w_(E E) = 11, w_(I I) = 5)$: passes level 1
  ($52 > 33.3$), but fails at level 2. Increasing $w_(I I)$ shifts
  the fixed points so that the actual $F'_E$ and $F'_I$ deviate
  from their optimal values, collapsing the feasibility window.

- $(w_(E E) = 20, w_(I I) = 0)$: passes level 1
  ($52 > 0$), but fails at level 2. Saturation pushes $F'_E
  approx 0$ at both fixed points, inflating the right-hand side
  of @eq:master far beyond $w_(E I)w_(I E) = 52$.
  
- $(w_(E E) = 14, w_(I I) = 2)$: passes level 1
  ($52 > 13.3$) and level 2 — the window exists. But fails at
  level 3: the saddle achieves $tau > 0$ ($w_(E E)F'_E$ exceeds
  the lower bound), yet $w_(E E)F'_E$ also exceeds the algebraic
  ceiling from @eq:det_upper, pushing $Delta < 0$. The actual
  operating point overshoots the window from above.

- $(w_(E E) = 11, w_(I I) = 0)$ and $(11, 1)$: all three levels
  satisfied. $w_(E E)$ places $u_E$ near $theta_E$, keeping
  $F'_E$ near-maximal, and the actual $w_(E E)F'_E$ falls within
  the feasibility window.



=== Monte Carlo validation

To test the framework beyond hand-picked parameters, we sampled
5000 random parameter combinations uniformly across wide ranges
($w_(E E), w_(E I), w_(I E) in [1, 30]$, $w_(I I) in [0, 20]$,
$tau_E, tau_I in [0.5, 30]$, $a_E, a_I in [0.5, 3]$,
$theta_E in [1, 10]$, $theta_I in [1, 20]$,
$I_E^"ext", I_I^"ext" in [-2, 5]$) and compared the analytical
predictions against numerical integration with oscillation
detection.

#figure(
  align(center)[
    #table(
      columns: (2.5fr, 1fr, 1fr, 1fr),
      align: (left, center, center, center),
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.hline(y: 1, stroke: 0.5pt),
      [*Category*], [*Count*], [*Oscillating*], [*Rate*],

      [Level 1 fail],
      [1698], [0], [0.00%],

      [Level 1 pass, Level 2 fail],
      [2613], [1], [0.04%],

      [Level 1–2 pass, Level 3 fail],
      [351], [15], [4.27%],

      [Level 3 pass],
      [338], [142], [42.01%],

      table.hline(stroke: 1pt)
    )
  ],
  caption: [Monte Carlo validation ($N = 5000$)#footnote[Oscillation
  detected via numerical integration (RK4) with periodicity
  analysis after transient removal.].],
)

The structural necessary condition (Level 1) is fully confirmed:
none of the 1698 samples that failed it produced oscillation. The
single Level 2 anomaly (1 out of 2613) has parameters
$w_(E E) = 18.8$, $w_(I I) = 13.6$, $tau_E = 5.1$,
$tau_I = 14.4$; the system has a single stable fixed point
(no unstable point), making a true limit cycle impossible.
This is a false positive from the oscillation detector.

Similarly, all 15 middle-zone oscillations and the single Level 2
anomaly involve systems with no unstable fixed point (U0/S1/Sad0
or U0/S2/Sad1). These are false positives from the oscillation
detector — slowly decaying spirals near the Hopf boundary — not
theoretical violations.

The Level 3 confirmation rate of 42% reveals an important refinement. Level 3 guarantees that
a fixed point is locally unstable (Hopf condition), but not that
a limit cycle forms. In multi-fixed-point systems, an unstable
spiral can coexist with stable attractors that capture
trajectories before a limit cycle develops. To verify this
interpretation, we partition the Level 3 passes by fixed-point
count:

#figure(
  align(center)[
    #table(
      columns: (2.5fr, 1fr, 1fr, 1fr),
      align: (left, center, center, center),
      stroke: none,
      table.hline(y: 0, stroke: 1pt),
      table.hline(y: 1, stroke: 0.5pt),
      [*Fixed-point structure*], [*Count*], [*Oscillating*], [*Rate*],

      [1 fixed point (unstable)],
      [145], [130], [89.7%],

      [3 fixed points],
      [162], [10], [6.2%],

      [Other],
      [31], [2], [6.5%],

      table.hline(stroke: 1pt)
    )
  ],
  caption: [Level 3 passes partitioned by fixed-point count.
  #footnote[Systems with a unique unstable fixed point oscillate at
  $approx 90%$; the gap from 100% is attributable to numerical
  limitations (fixed-point detection and oscillation
  sensitivity). Multi-fixed-point systems rarely oscillate
  despite passing Level 3, confirming that competing stable
  attractors suppress limit cycle formation.]],
)

The 10 oscillating three-fixed-point cases all share the
classification U1/S1/Sad1 (one unstable spiral, one stable
attractor, one saddle). No U2/S0/Sad1 configuration — in which
a global limit cycle could enclose all three fixed points — was
observed. This indicates that the observed oscillations are
basin-restricted#footnote[Whether the 10 three-fixed-point oscillations represent true
(supercritical Hopf) limit cycles coexisting with the stable
attractor or transient spirals that eventually decay would require
computing the first Lyapunov coefficient at the unstable fixed
point, which is a direction left for future investigation.]: trajectories initiated near the unstable spiral
orbit within its basin before eventually being captured by the
competing stable attractor, producing transient oscillatory
behaviour that the detector registers as periodic.

 *Across all 5000 samples, zero genuine
violations of the analytical framework were observed.*

The complete sufficient condition for oscillation in the
Wilson-Cowan model is therefore:

#align(center)[
  _Level 3 satisfied at the system's *unique* fixed point._
]

When a single fixed point exists and is an unstable spiral, the
system is bounded ($r_E, r_I in [0, 1]$)#footnote[With correction term it's slightly different.] and contains no other
attractor, so the Poincaré-Bendixson theorem guarantees a limit
cycle.

== Further discussion

Our analytical conditions are consistent with the numerical
bifurcation results of Li et al. (2022), who investigated the
role of self-feedback loops in regulating gamma oscillations in
the Wilson-Cowan model.

Their one-parameter bifurcation with respect to $w_(I I)$ (their
Figure 3A) shows that increasing inhibitory self-feedback
suppresses oscillation. This follows directly from the structural
condition (@eq:structural): the right-hand side
$(16 tau_E w_(I I))/(tau_I a_E)$ grows linearly with $w_(I I)$,
so for fixed cross-coupling $w_(E I)w_(I E)$, sufficiently large
$w_(I I)$ will always violate the inequality. In the full master
inequality (@eq:master), $w_(I I)$ enters quadratically through
$(1 + w_(I I)F'_I)^2$, making its suppressive effect even
stronger at realised fixed points.

For excitatory self-feedback, their one-parameter bifurcation
with respect to $w_(E E)$ (their Figure 6A) reveals that
oscillation exists only within a limited window
($13.57 < w_(E E) < 35$). Their study concludes that "the
excitatory self-feedback loop promotes the generation of gamma
oscillations". However, this statement captures only the lower
boundary of the window.

Their transfer function analysis correctly identifies the
qualitative trend: increasing $w_(E E)$ drives the excitatory
population toward instability. Quantitatively, however, the
closed-loop gain formula (their Eq. 13) requires
$w_(E E) F'_E < 1$, while the Hopf trace condition demands
$w_(E E) F'_E > 1$. The two-dimensional Jacobian analysis
developed here covers the oscillatory regime directly without
this restriction.

Since $w_(E E)$ does not appear in the structural condition
(@eq:structural), its role is not to determine _whether_ the
network can support oscillation — that is governed by
$w_(E I)w_(I E)$, $w_(I I)$, $tau_E\/tau_I$, and $a_E$.
Rather, $w_(E E)$ determines whether oscillation is _realised_,
by tuning the fixed point into the feasibility window. Within
this window, increasing $w_(E E)$ does promote oscillation —
it drives $w_(E E)F'_E$ above the trace threshold, consistent
with Li et al.'s conclusion. But this promotion is bounded
above: excessive $w_(E E)$ either pushes $u_E$ past $theta_E$
into saturation (collapsing $F'_E$, causing the trace itself
to fail), or, even before saturation, drives $w_(E E)F'_E$
above the algebraic ceiling from @eq:det_upper, producing a
Saddle. The complete picture is therefore that $w_(E E)$ acts
as a _tuning parameter_ with a finite effective range, not a
monotonic promoter of oscillation.

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



= Limitations

Several limitations of the present analysis should be noted.

*Decoupled optimisation.* The structural condition 
is obtained by independently maximising $F'_E$ and minimising the
cost over $F'_I$. In the actual system, both derivatives are
jointly determined by a single fixed point on the nullcline
intersection, and may not simultaneously attain their optimal
values. This makes @eq:structural a potentially loose bound:
the gap between structural necessity and actual oscillation is
quantified by the three-level framework in sufficiency, but
no closed-form sufficient condition was obtained (see the section 5).

*Finite numerical scope.* The Monte Carlo study ($N = 5000$)
found no three-fixed-point system with two unstable equilibria
(U2/S0/Sad1), but this is an empirical observation, not a
topological proof. The Poincaré index theorem permits a limit
cycle enclosing all three such fixed points (index sum $= +1$),
so this configuration cannot be ruled out in other parameter
regimes.

*Sigmoid form.* All results assume the specific sigmoid
with the correction term $F(0) = 0$. The original
Wilson-Cowan formulation includes a refractory term $(1 - r_E)$
which modifies the effective gain; our conditions do not directly
apply to that variant.

*Single-population time constants.* The model assumes each
population is characterised by a single time constant. Distributed
delays or synaptic filtering (as in Keeley et al. (2019)) may
shift the oscillatory boundaries quantitatively, though the
qualitative structure of the trace-determinant framework is
preserved.

= Future work

The Monte Carlo validation identifies a sharp empirical boundary:
Level 3 at a unique fixed point yields oscillation at $approx
90%$, whereas Level 3 at one of three fixed points yields only
$approx 6%$. Detailed logging reveals that all oscillating
three-fixed-point systems have configuration U1/S1/Sad1 (one
unstable, one stable, one saddle); no U2/S0/Sad1 configuration
was observed. This suggests that three-fixed-point oscillation in
the sampled parameter range occurs through basin-restricted limit
cycles around the unstable spiral, rather than global limit cycles
enclosing all three fixed points.

A natural next step is to derive, from parameters alone, whether
there exists an $I_E^"ext"$ that produces a unique unstable fixed
point. The key geometric ingredient is the E-nullcline fold. The
trace condition requires $w_(E E) F'_E > 1$, which at the sigmoid
midpoint demands $w_(E E) > 4 slash a_E$. But this is precisely
the condition for the E-nullcline to be non-monotone (S-shaped),
guaranteeing multiple fixed points at some input levels. As
$I_E^"ext"$ increases, the E-nullcline shifts upward until a
saddle-node bifurcation annihilates two fixed points, leaving a
unique equilibrium. If this surviving fixed point satisfies the
Hopf condition, a limit cycle is guaranteed by the
Poincaré-Bendixson theorem.

The question therefore reduces to whether the Hopf bifurcation
occurs in the one-fixed-point region of the $(I_E^"ext",
w_(E E))$ parameter plane — a codimension-2 problem involving the
interaction between saddle-node and Hopf bifurcation curves. This
Bogdanov-Takens / saddle-node-Hopf analysis is a standard topic
in bifurcation theory (see Izhikevich (2007), Ch. 6; Kuznetsov
(2004), Ch. 8) but requires case-specific computation for the
Wilson-Cowan sigmoid. Completing this analysis would close the gap
between structural necessity (Equation 33) and a fully parametric
sufficient condition, eliminating the need for fixed-point
enumeration.


= Key References

+ *Wilson, H.R. & Cowan, J.D. (1972).* Excitatory and inhibitory interactions in localized populations of model neurons. _Biophysical Journal_, 12(1), 1–24. doi: #link("https://doi.org/10.1016/S0006-3495(72)86068-5")[10.1016/S0006-3495(72)86068-5]

+ *Wilson, H.R. & Cowan, J.D. (1973).* A mathematical theory of the functional dynamics of cortical and thalamic nervous tissue. _Kybernetik_, 13(2), 55–80. doi: #link("https://doi.org/10.1007/BF00288786")[10.1007/BF00288786]

+ *Destexhe, A. & Sejnowski, T.J. (2009).* The Wilson-Cowan model, 36 years later. _Biological Cybernetics_, 101(1), 1–2. doi: #link("https://doi.org/10.1007/s00422-009-0328-3")[10.1007/s00422-009-0328-3]

+ *Jadi, M.P. & Sejnowski, T.J. (2014).* Regulating cortical oscillations in an inhibition-stabilized network. _Proceedings of the IEEE_, 102(5), 830–842. doi: #link("https://doi.org/10.1109/JPROC.2014.2313113")[10.1109/JPROC.2014.2313113]

+ *Keeley, S., Byrne, Á., Fenton, A. & Rinzel, J. (2019).* Firing rate models for gamma oscillations. _Journal of Neurophysiology_, 121(6), 2181–2190. doi: #link("https://doi.org/10.1152/jn.00741.2018")[10.1152/jn.00741.2018]

+ *Li, D., Liu, S. & Wang, J. (2022).* Bidirectionally regulating gamma oscillations in Wilson-Cowan model by self-feedback loops: a computational study. _Frontiers in Systems Neuroscience_, 16, 723237. doi: #link("https://doi.org/10.3389/fnsys.2022.723237")[10.3389/fnsys.2022.723237]

+ *#link("https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html")[Neuromatch Academy — Computational Neuroscience, W2D4: Dynamic Networks]*
