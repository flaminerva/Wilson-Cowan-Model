## Wilson-Cowan Model

In [computational neuroscience](https://en.wikipedia.org/wiki/Computational_neuroscience "Computational neuroscience"), the **Wilson-Cowan model** ([Hugh R. Wilson](https://en.wikipedia.org/w/index.php?title=H.R._Wilson&action=edit&redlink=1 "H.R. Wilson (page does not exist)") & [Jack D. Cowan](https://en.wikipedia.org/wiki/Jack_D._Cowan "Jack D. Cowan")) describes the dynamics of interactions between populations of very simple excitatory and inhibitory model [neurons](https://en.wikipedia.org/wiki/Neuron "Neuron"). It is a mean-field model that tracks the **proportion of active neurons** in each population over time.

[^1]![[fnsys-16-723237-g001.webp]]

$$\tau_E \frac{dr_E}{dt} = -r_E + F_E(w_{EE} \cdot r_E - w_{EI} \cdot r_I + I^{ext}_E)$$

$$\tau_I \frac{dr_I}{dt} = -r_I + F_I(w_{IE} \cdot r_E - w_{II} \cdot r_I + I^{ext}_I)$$

where the activation function $F$ is a sigmoid:

$$F(x; a, \theta) = \frac{1}{1 + e^{-a(x - \theta)}} - \frac{1}{1 + e^{a\theta}}$$

The correction term $-\frac{1}{1 + e^{a\theta}}$ ensures $F(0) = 0$ (no input yields no activation).

> **Remark**: We use the simplified Wilson-Cowan equations without the refractory term $(1−rE)$, following the formulation in [Neuromatch Academy](https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html). 

### Variables

- $r_E(t)$ — average firing rate (or proportion of active neurons) of the **excitatory** population at time $t$. Ranges from 0 (silent) to 1 (maximally active).
- $r_I(t)$ — average firing rate of the **inhibitory** population at time $t$.

### Parameters

#### Time Constants

- $\tau_E$ — time constant of the excitatory population. Controls how quickly E responds to input.
- $\tau_I$ — time constant of the inhibitory population. A larger $\tau_I$ relative to $\tau_E$ means inhibition is slower, which can promote oscillations.

#### Sigmoid Parameters

- $a_E$, $a_I$ — gain (steepness) of the activation function for E and I populations. Higher gain means a sharper threshold-like response.
- $\theta_E$, $\theta_I$ — threshold of the activation function. The input level at which the population reaches half-maximal activation.

#### Connection Weights

- $w_{EE}$ — excitatory → excitatory coupling strength (recurrent excitation).
- $w_{EI}$ — inhibitory → excitatory coupling strength (how much I suppresses E).
- $w_{IE}$ — excitatory → inhibitory coupling strength (how much E drives I).
- $w_{II}$ — inhibitory → inhibitory coupling strength (recurrent inhibition).

#### External Inputs

- $I^{ext}_E$ — external input current to the excitatory population (primary control parameter for bifurcation analysis).
- $I^{ext}_I$ — external input current to the inhibitory population (typically fixed at 0).

### Parameter Values

| Parameter   | Value  | Description                                              |
| ----------- | ------ | -------------------------------------------------------- |
| $\tau_E$    | 1.0 ms | Average synaptic time constant for excitatory population |
| $\tau_I$    | 2.0 ms | Average synaptic time constant for inhibitory population |
| $a_E$       | 1.2    | Excitatory gain                                          |
| $a_I$       | 1.0    | Inhibitory gain                                          |
| $\theta_E$  | 2.8    | Excitatory threshold                                     |
| $\theta_I$  | 4.0    | Inhibitory threshold                                     |
| $w_{EE}$    | 9.0    | Strength of self-excitatory feedback                     |
| $w_{EI}$    | 4.0    | Strength of connections between _E–I_                    |
| $w_{IE}$    | 13.0   | Strength of connections between _I-E_                    |
| $w_{II}$    | 11.0   | Strength of self-inhibitory feedback                     |
| $I^{ext}_E$ | 0.0    | External input to excitatory population (sweep this)     |
| $I^{ext}_I$ | 0.0    | External input to inhibitory population                  |

These values are from the Neuromatch Academy computational neuroscience curriculum.

> **Remark**: The parameters play an important role in the system, please read the *Periodic solution (Oscillations)* part in details. 


### Nullcline Analysis

#### E-nullcline

Let $\dot{r}_E = 0$, then

$$\frac{1}{\tau_E}\left(-r_E + F_E(w_{EE} \cdot r_E - w_{EI} \cdot r_I + I^{ext}_E)\right) = 0$$

$$-r_E + F_E(w_{EE} \cdot r_E - w_{EI} \cdot r_I + I^{ext}_E) = 0$$

$$F_E(w_{EE} \cdot r_E - w_{EI} \cdot r_I + I^{ext}_E) = r_E$$

Then we use the inverse of $F$ (namely the logit function):

$$F^{-1}(y;, a, \theta) = \theta + \frac{1}{a}\ln\frac{y + c}{1 - y - c}, \quad c = \frac{1}{1 + e^{a\theta}}$$

Applying $F_E^{-1}$ to both sides:

$$F_E^{-1}(r_E) = w_{EE} \cdot r_E - w_{EI} \cdot r_I + I^{ext}_E$$

Solving for $r_I$:

$$r_I = \frac{1}{w_{EI}}\left(w_{EE} \cdot r_E - F_E^{-1}(r_E) + I^{ext}_E\right)$$

#### I-nullcline

Analogously, let $\dot{r}_I = 0$, we have

$$r_E = \frac{1}{w_{IE}}\left(w_{II} \cdot r_I + F_I^{-1}(r_I) - I^{ext}_I\right)$$

#### Substituting Default Parameters

The correction terms for each population are:

$$c_E = \frac{1}{1 + e^{1.2 \times 2.8}} = \frac{1}{1 + e^{3.36}} \approx 0.0336$$

$$c_I = \frac{1}{1 + e^{1.0 \times 4.0}} = \frac{1}{1 + e^{4.0}} \approx 0.0180$$

The inverse activation functions become:

$$F_E^{-1}(r_E) = 2.8 + \frac{5}{6}\ln\frac{r_E + 0.0336}{0.9664 - r_E}$$

$$F_I^{-1}(r_I) = 4.0 + \ln\frac{r_I + 0.0180}{0.9820 - r_I}$$

2 ($w_{EE} = 9$, $w_{EI} = 4$, $I^{ext}_E = 0$):

$$r_I = \frac{1}{4}\left(9 r_E - 2.8 - \frac{5}{6}\ln\frac{r_E + 0.0336}{0.9664 - r_E}\right)$$

**I-nullcline** ($w_{IE} = 13$, $w_{II} = 11$, $I^{ext}_I = 0$):

$$r_E = \frac{1}{13}\left(11r_I + 4.0 + \ln\frac{r_I + 0.0180}{0.9820 - r_I}\right)$$

> **Remark:** The domains are $r_E \in (0,; 0.9664)$ and $r_I \in (0,; 0.9820)$, as the logarithm requires its argument to be positive.

In the end we obtain the figure

![[Pasted image 20260224144658.png]]

Inserting point (0.1,0.5), it's easy to check the arrow direction. We omit here.

### Qualitative analysis

> **Remark**: In the later sections (if there are) except this one, we will omit the calculation process of Jacobian.

Note that in the previous section, we obtain the phase plane with 3 equilibrium points. Now we use the Jacobian matrix to determine its state.
Recall the Jacobian matrix:


$$J = \begin{pmatrix}
\frac{\partial \dot{r}_E}{\partial r_E} & \frac{\partial \dot{r}_E}{\partial r_I} \\
\frac{\partial \dot{r}_I}{\partial r_E} & \frac{\partial \dot{r}_I}{\partial r_I}
\end{pmatrix}$$

We solve the partial derivative and obtain

$$J = \begin{pmatrix} \frac{1}{\tau_E}(-1 + w_{EE} \cdot F'_E) & \frac{1}{\tau_E}(-w_{EI} \cdot F'_E)\\
\ \frac{1}{\tau_I}(w_{IE} \cdot F'_I) & \frac{1}{\tau_I}(-1 - w_{II} \cdot F'_I) \end{pmatrix}$$

in which 
$$F'(x) = a \cdot (F(x)+c)(1 - F(x) - c), \quad c = \frac{1}{1+e^{a\theta}}$$

Note that $F'$ is evaluated at the sigmoid input, not at $r_E$ or $r_I$ directly:

$$u_E = w_{EE} r_E - w_{EI} r_I + I^{ext}_E, \quad u_I = w_{IE} r_E - w_{II} r_I + I^{ext}_I$$

We classify each fixed point using the trace $\tau = \text{tr}(J)$, determinant $\Delta = \det(J)$, and discriminant $\tau^2 - 4\Delta$ of the Jacobian:

- $\Delta < 0 \Rightarrow$ saddle point
- $\Delta > 0, ; \tau < 0 \Rightarrow$ stable (node if $\tau^2 - 4\Delta > 0$, spiral if $< 0$)
- $\Delta > 0, ; \tau > 0 \Rightarrow$ unstable

For our 3 fixed points:

- **(0, 0):**
$$J = \begin{pmatrix} -0.650 & -0.156 \\ 0.115 & -0.597 \end{pmatrix}$$

	$$\tau = -1.247, \quad \Delta = 0.406, \quad \tau^2 - 4\Delta = 1.555 - 1.624 = -0.069 < 0$$
	We have $\tau^2 - 4\Delta < 0$. This is a **stable spiral**.
	

- **(≈0.34, 0.17):**
	$$J = \begin{pmatrix} 1.535 & -1.127 \\ 1.000 & -1.347 \end{pmatrix}$$
	
	We have $\Delta = -0.941 < 0$. This is a **saddle point**.
	

- **(≈0.94, 0.68):**
	$$J = \begin{pmatrix} -0.700 & -0.133 \\ 1.422 & -1.703 \end{pmatrix}$$
	
	We have $\Delta = 1.381 > 0$, $\tau = -2.403 < 0$, and $\tau^2 - 4\Delta = 0.250 > 0$. This is a **stable node**.

The system with default parameters ($I^{ext}_E = 0$) is therefore **bistable**.
(In a [dynamical system](https://en.wikipedia.org/wiki/Dynamical_system "Dynamical system"), **bistability** means the system has two [stable equilibrium states](https://en.wikipedia.org/wiki/Stability_theory "Stability theory") **bistable structure** can be resting in either of two states.)


### Periodic solution (Oscillations)

Recall the **Poincaré-Bendixson theorem** states that for a two-dimensional system, for which we know that the solutions will stay in **a bounded area** after some finite time and there is **no fixed point**, there must exist a periodic solution to which the trajectories converge.

We sweep the $I^{ext}_E$ until we obtain only one fixed point which is unstable.
![[Screenshot 2026-02-25 at 22.26.59.png]]

Note that after sweeping $I^{ext}_E$, We only get the stable 1 fixed point, why?

**!!!IMPORTANT!!!**
--
Under the NMA default parameters, the system **cannot produce oscillations**. Sweeping $I^{ext}_E$ reveals that the unique remaining fixed point after the saddle-node bifurcation always lies in the sigmoid saturation region ($F'_E \approx 0$), making the Jacobian trace $\tau$ permanently negative. The Hopf bifurcation condition $\tau > 0$ is never met.

This is not a limitation of the Wilson-Cowan model itself, but a consequence of the parameter choice. The NMA parameters are designed to demonstrate **bistability** (working memory), not oscillations.  Comparing with the parameters used in [Li et al. (2022)](https://doi.org/10.3389/fnsys.2022.723237) (Table 1, based on [Wilson and Cowan (1972)](https://doi.org/10.1016/S0006-3495\(72\)86068-5) and [Jadi and Sejnowski (2014)](https://doi.org/10.1109/JPROC.2014.2313113)) for gamma oscillation research:

| Parameter              | NMA (bistability) | Table1 (oscillation) |
| ---------------------- | ----------------- | -------------------- |
| $w_{EE}$               | 9                 | 16                   |
| $w_{EI}$               | 4                 | 26                   |
| $w_{IE}$               | 13                | 20                   |
| $w_{II}$               | 11                | 1                    |
| $\tau_E$ (ms)          | 1                 | 20                   |
| $\tau_I$ (ms)          | 2                 | 10                   |
| $\theta_E, \theta_I$   | 2.8, 4.0          | 5, 20                |
| $I^{ext}_E, I^{ext}_I$ | 0, 0              | 2, 7                 |

Regarding the influence of parameters, we refer to the following papers rather than reproducing their analysis:

- **Inhibitory self-feedback.** [Li et al. (2022)](https://doi.org/10.3389/fnsys.2022.723237):
> The present results reveal that, on one hand, the inhibitory self-feedback loop is not conducive to the generation of gamma oscillations, and increased inhibitory self-feedback strength facilitates the enhancement of the oscillation frequency. On the other hand, the excitatory self-feedback loop promotes the generation of gamma oscillations [...] Inhibitory and excitatory self-feedback loops play a complementary role in generating and regulating the gamma oscillation in Wilson-Cowan model.

- **Time constants.** [Keeley et al. (2019)](https://doi.org/10.1152/jn.00741.2018): 
> The models' flexibility to capture the broad range of gamma behavior depends directly on the timescales that represent recruitment of the excitatory and inhibitory firing rates. In particular, we find that weakly modulated gamma oscillations occur robustly when the recruitment timescale of inhibition is faster than that of excitation.


### Key References

1. **Wilson, H.R. & Cowan, J.D. (1972).** Excitatory and inhibitory interactions in localized populations of model neurons. _Biophysical Journal_, 12(1), 1–24. doi: [10.1016/S0006-3495(72)86068-5](https://doi.org/10.1016/S0006-3495\(72\)86068-5)
    
2. **Wilson, H.R. & Cowan, J.D. (1973).** A mathematical theory of the functional dynamics of cortical and thalamic nervous tissue. _Kybernetik_, 13(2), 55–80. doi: [10.1007/BF00288786](https://doi.org/10.1007/BF00288786)
    
3. **Destexhe, A. & Sejnowski, T.J. (2009).** The Wilson-Cowan model, 36 years later. _Biological Cybernetics_, 101(1), 1–2. doi: [10.1007/s00422-009-0328-3](https://doi.org/10.1007/s00422-009-0328-3)
    
4. **Jadi, M.P. & Sejnowski, T.J. (2014).** Regulating cortical oscillations in an inhibition-stabilized network. _Proceedings of the IEEE_, 102(5), 830–842. doi: [10.1109/JPROC.2014.2313113](https://doi.org/10.1109/JPROC.2014.2313113)
    
5. **Keeley, S., Byrne, Á., Fenton, A. & Rinzel, J. (2019).** Firing rate models for gamma oscillations. _Journal of Neurophysiology_, 121(6), 2181–2190. doi: [10.1152/jn.00741.2018](https://doi.org/10.1152/jn.00741.2018)
    
6. **Li, D., Liu, S. & Wang, J. (2022).** Bidirectionally regulating gamma oscillations in Wilson-Cowan model by self-feedback loops: a computational study. _Frontiers in Systems Neuroscience_, 16, 723237. doi: [10.3389/fnsys.2022.723237](https://doi.org/10.3389/fnsys.2022.723237)
    
7. **[Neuromatch Academy — Computational Neuroscience, W2D4: Dynamic Networks](https://compneuro.neuromatch.io/tutorials/W2D4_DynamicNetworks/student/W2D4_Tutorial2.html)**

[^1]: Schematic of the Wilson-Cowan model. _E_ represents the excitatory populations, _I_ stands for the inhibitory populations, the red arrows indicate the excitatory projections and blue arrows show the inhibitory projections, _i__I_ is the external inputs of the _I_ populations, and _i__E_ is the external inputs of the _E_ populations.[Li et al. (2022)](https://doi.org/10.3389/fnsys.2022.723237)
