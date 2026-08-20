# Case study: Kolmogorov 1941 — deriving a law of nature from units

Physics/frontier case. In 1941, from essentially *two sentences of
phenomenology and a units check*, Kolmogorov derived the most successful
scaling law in turbulence — including its failure modes, which took eighty
years of experiments to map. The lesson: dimensional analysis is a
hypothesis generator, and its outputs stay HYPOTHESIZED until measured.

## 1. The phenomenology (two sentences)

Forced turbulence moves energy from a large forcing scale $L$ down a
cascade of eddies to a small dissipation scale $\eta$, where viscosity
converts it to heat. K41 postulates, in the *inertial range*
$\eta \ll \ell \ll L$:

1. statistics of scale-$\ell$ increments depend only on the mean energy
   dissipation rate per unit mass $\varepsilon$ and on $\ell$ (universality,
   local isotropy);
2. viscosity $\nu$ is irrelevant in this range (inertia dominates).

Both postulates are *falsifiable assumptions*, not facts — remember this.

## 2. The units force the answer

Units: length $[\ell] = \mathrm{m}$; energy per mass per time
$[\varepsilon] = \mathrm{m^2/s^3}$ (kinetic energy per mass is
$\mathrm{m^2/s^2}$; rate divides by time); velocity increment
$[\delta u] = \mathrm{m/s}$.

Seek $\delta u(\ell) = C\, \varepsilon^a \ell^b$ — the postulates leave
nothing else to combine. Matching units:

$$
\mathrm{m/s} = (\mathrm{m^2/s^3})^a \, \mathrm{m}^b
= \mathrm{m}^{2a+b}\, \mathrm{s}^{-3a}
\;\Longrightarrow\;
-3a = -1,\; 2a + b = 1
\;\Longrightarrow\;
a = \tfrac13,\; b = \tfrac13.
$$

Two linear equations, two unknowns, one possible law:
$\delta u(\ell) \sim (\varepsilon \ell)^{1/3}$ — increments scale as
$\ell^{1/3}$. PROVEN as a consequence of the postulates; the postulates
themselves remain the live question.

The second-order structure function and the dissipation scale fall out the
same way:

$$
S_2(\ell) := \langle |\delta u(\ell)|^2 \rangle = C_2 (\varepsilon \ell)^{2/3},
\qquad
\eta := \Big(\frac{\nu^3}{\varepsilon}\Big)^{1/4},
$$

the latter from balancing inertial turnover $\delta u(\eta) \cdot \eta$
against diffusion $\nu$: $(\varepsilon\eta)^{1/3}\eta/\nu = 1$, solved:
$\eta^{4/3} = \nu^3/\varepsilon$. Units check of $\eta$:
$[(\mathrm{m^2/s})^3 / (\mathrm{m^2/s^3})]^{1/4}
= [\mathrm{m^4}]^{1/4} = \mathrm{m}$. ✓

**Numeric fixture (air):** $\nu = 1.5 \times 10^{-5}\, \mathrm{m^2/s}$,
$\varepsilon = 10^{-3}\, \mathrm{m^2/s^3}$ (atmospheric boundary layer):
$\eta = (3.375\times10^{-15} / 10^{-3})^{1/4}
= (3.375\times10^{-12})^{1/4} \approx 1.4\times10^{-3}\,$m.
A millimeter: the cascade's end, from two units and a balance condition.

## 3. The spectrum: $k^{-5/3}$

Let $E(k)$ be the energy spectral density: energy in wavenumber shell
$[k, k+dk)$ is $E(k)\,dk$, so $[E] = \mathrm{m^3/s^2}$. Local-Fourier
reading: scale-$\ell$ increments feed on shells near $k \sim 1/\ell$, so
$S_2(\ell) \sim \int_k^\infty E(k')\,dk'$ *at the scaling level* (heuristic,
tagged; made precise as an additivity-of-shells statement via Fourier —
GAP). Then $S_2 \sim \ell^{2/3} \sim k^{-2/3}$ forces, by differentiating
the band-pass identity $\frac{d}{dk}\int_k^\infty E = -E(k)$:

$$
E(k) = C_K\, \varepsilon^{2/3}\, k^{-5/3}.
$$

Units check: $[\varepsilon^{2/3} k^{-5/3}]
= (\mathrm{m^2/s^3})^{2/3} \mathrm{m}^{-5/3}
= \mathrm{m}^{4/3-5/3}\mathrm{s}^{-2} = \mathrm{m}^{-1/3}$... that is *not*
$\mathrm{m^3/s^2}$ — **catch the error before proceeding**: the shell index
$k$ is a *wavenumber*, $[k] = \mathrm{m}^{-1}$, so
$[k^{-5/3}] = \mathrm{m}^{5/3}$, and
$[E] = \mathrm{m}^{4/3}\mathrm{s}^{-2}\cdot \mathrm{m}^{5/3} =
\mathrm{m}^3\mathrm{s}^{-2}$. ✓ (Dimensional analysis double-checks are not
optional; the first reading was wrong.)

The measured constant $C_K \approx 1.5$–$1.6$ and the $-5/3$ exponent hold
across an absurd range of flows (ocean, atmosphere, pipe, superfluid
helium) — SUPPORTED, massively.

## 4. The one exact island: the 4/5 law

Under the same postulates plus incompressibility, the Kármán–Howarth
equation (an exact consequence of Navier–Stokes — cited) closes to an
*exact* relation:

$$
S_3(\ell) := \langle (\delta u_\parallel(\ell))^3 \rangle = -\tfrac{4}{5}\, \varepsilon\, \ell
\qquad (\eta \ll \ell \ll L).
$$

Third order is skewness — the asymmetry that *carries* the cascade
direction (third moments are odd; time-irreversibility enters here).
Derivation: GAP (it is three pages of isotropic tensor identities). Its
role in the theory: it *pins* $\varepsilon$ from data — measure $S_3$'s
slope — and it is the control that certifies the inertial range exists at
all. HYPOTHESIZED-scaling §2–3 now has an anchor: $\varepsilon$ is no
longer a fitted parameter.

## 5. Where it breaks: intermittency (the live frontier)

K41 predicts all orders: $S_p(\ell) \sim \ell^{\,p/3}$, hence
$\zeta_p = p/3$. Measurements: $\zeta_3 = 1$ exactly (by §4: theory says
$\zeta_3 = 1$ *without* dimensional counting, and it survives), but
$\zeta_2 \approx 0.70$ (close to $2/3$, small anomaly) and $\zeta_6
\approx 1.78 \neq 2$ (large anomaly). High moments probe rare, violent
events — vortex filaments, sharp fronts — and *rare* is exactly what the
uniformity postulate (§1.1) got wrong. Status of K41: spectrum broadly
SUPPORTED, higher orders REFUTED, repair = multifractal/log-Poisson models
(SUPPORTED phenomenologically, no derivation from Navier–Stokes — open).

The deep connection — Onsager (1949): anomalous dissipation requires
roughness, and $\delta u \sim \ell^{1/3}$ *is precisely* the threshold
regularity. Constantin–E–Titi (1994): energy is conserved for weak
solutions smoother than $C^{1/3}$; Isett (2018, closing the
Buckmaster–De Lellis–Székelyhidi program): solutions below $C^{1/3}$ can
dissipate without viscosity at all. Kolmogorov's exponent, derived from
units, sits exactly on a theorem's boundary. All cited frontier results.

## 6. Method summary

postulates (tagged) → units (proved) → spectrum (proved from postulates +
one heuristic, tagged) → one exact law (cited) → systematic experimental
falsification of the higher orders → the exponent is rescued, eighty years
later, as the sharp threshold of a conservation theorem. This is the
physics loop from the schema site: hypothesize, test, let reality revise
the model — run for a century.
