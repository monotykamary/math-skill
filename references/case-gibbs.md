# Case study: maximum entropy, and why the Gibbs tilt is a rate function

Statistical mechanics case, and the debt-payer for case-large-deviations.md:
that file built the exponential tilt and the rate function, then cited Sanov
in section 7 without proving the correspondence. Here the correspondence
pays through a complete derivation on a finite state space. Tools: one
tangent inequality, one completion of squares, one derivative. Fitting to the
course: the tilting engine from large deviations turns out to be
thermodynamics in thin notation.

## 1. The setting

$N$ states, $i = 1..N$, energy $E\_i$ on state $i$. A probability
distribution $p$ on the states. Entropy (in nats):
$H(p) = -\sum\_i p\_i \ln p\_i$, with $0 \ln 0$ set to $0$ (the extension
is continuous: $x \ln x \to 0$ as $x \to 0$, a standard limit that
follows from $x \ln x \le x$... justify via the exponential decay of
heaviness: state as a defined convention and note the limit exists).
Constraint: the mean energy under $p$ must equal $U$, that is
$\sum\_i p\_i E\_i = U$.

Question: among all $p$ meeting the constraint, which maximizes $H$?
Answer, called the Gibbs distribution:
$p\_i = e^{\beta(\psi - E\_i)}$ with some scalar
$\beta$ and normalizer.

## 2. The one tool: the tangent inequality

For $x > 0$: $\ln x \le x - 1$, with equality exactly at $x = 1$. Proof
from the concavity of $\ln$: the tangent at $x = 1$ has slope 1 (the
derivative of $\ln$ at 1 is 1), and a concave function lies below each of
its tangents (definition of concavity applied to the chord:
$f(y) \le f(1) + f'(1)(y-1)$ ); substitute $y = x$. Equality in the
tangent property exactly where the chord degenerates, at $x = 1$.
Status: PROVEN, taking the tangent characterization of concavity as the
named premise (the same characterization the course's one machinery
enables in case-max-principle.md section 1).

Now the relative entropy of a test measure $q$ against a reference $p$:
$D(q \ \parallel\  p) := \sum\_i q\_i \ln(q\_i/p\_i)$. By the tangent inequality at
$x = q\_i/p\_i$ (each ratio is positive when $p\_i > 0$ on the support,
checked termwise):

$$
\sum\_i q\_i \ln(q\_i/p\_i) \ge \sum\_i q\_i (1 - p\_i/q\_i)
= \sum\_i q\_i - \sum\_i p\_i = 1 - 1 = 0.
$$

Each step: multiply the tangent inequality by $q\_i \ge 0$ (sign
preserved), sum (summation of inequalities preserves inequality), then
both sums are 1 because $q$ and $p$ are measures. Equality throughout
exactly when every ratio is 1, that is $q = p$. PROVEN:
$D(q \ \parallel\  p) \ge 0$, equality exactly at $q = p$. This one inequality
runs the whole case.

## 3. Gibbs is the unique entropy maximizer

Fix $\beta$ for now, and define the candidate
$p\_i = e^{-\beta E\_i}/Z$ with $Z(\beta) := \sum\_i e^{-\beta E\_i}$.
For ANY $q$ on the simplex:

$$
-\sum\_i q\_i \ln p\_i = \sum\_i q\_i (\beta E\_i + \ln Z)
= \beta\Bigl(\sum\_i q\_i E\_i\Bigr) + \ln Z.
$$

(Each step: substitute $\ln p\_i = -\beta E\_i - \ln Z$; linearity of the sum;
$\sum\_i q\_i = 1$.) If $q$ also meets the mean constraint, $\sum\_i q\_i E\_i = U$,
so $-\sum\_i q\_i \ln p\_i = \beta U + \ln Z$, the same number for every
admissible $q$. Apply section 2 with reference $p$:
$D(q \ \parallel\  p) = -H(q) + \sum\_i q\_i(-\ln p\_i)$? Check the exact
identity:
$D(q \ \parallel\  p) = \sum\_i q\_i \ln q\_i - \sum\_i q\_i \ln p\_i = -H(q) - \sum\_i q\_i \ln p\_i$.
Therefore

$$
H(q) = -D(q \ \parallel\  p) - \sum\_i q\_i \ln p\_i
\le -\sum\_i q\_i \ln p\_i = \beta U + \ln Z.
$$

And equality iff $q = p$ by section 2's sharpness. So every admissible
$q$ has entropy at most $\beta U + \ln Z$, with the maximum attained only
at $p$. Also $H(p)$ itself equals $\beta U + \ln Z$ ($p$ is admissible and
satisfies the inequality with equality). PROVEN:
$p\_i = e^{-\beta E\_i}/Z(\beta)$ maximizes $H$ uniquely under mean
$E = U$, whenever $\beta$ is chosen so that $p$ has mean $U$. The Lagrange
multiplier method arrives by a completely different route; here it needs
no smooth variation, only the tangent inequality.

## 4. Matching beta to U: the tilt, inverted

The relation between $\beta$ and $U$ is monotone. On the two-state example in
section 5, this is visible; the general fact is a derivative computation
identical to the convexity proof of case-large-deviations.md section 3:
substitute $t = -\beta$ there (their name $Z\_t$, tilt toward low energy, is our
$e^{\beta(\dots)}$ up to sign).
$\frac{dU}{d\beta} = \sum\_i E\_i \frac{d p\_i}{d\beta}$ and
$\frac{d}{d\beta} \frac{e^{-\beta E\_i}}{Z} = p\_i\bigl(-E\_i + \frac{d(\ln Z)}{d\beta}\bigr)$
by the chain rule split of the log:
$\frac{d}{d\beta} \ln Z = \frac{1}{Z} \sum\_i (-E\_i) e^{-\beta E\_i} = -U$
(derivative of the log of a sum, applied at each term). Then
$\frac{dU}{d\beta} = \sum\_i E\_i p\_i (-E\_i + U) = -(\mathbb{E}[E^2] - U^2) = -\mathrm{Var}\_p(E) \le 0$:
the derivative is a variance, exactly the tilted-variance identity of
case-large-deviations.md section 3. Variance is nonnegative; it is zero only on
one-point energy sets (a variance vanishes iff its variable is constant, shown
there by the same expansion). PROVEN: $U(\beta)$ weakly decreases, strictly
when energies differ. So the matching $\beta(U)$ exists and is unique on the
attainable range of $U$ (monotone functions have at most one inverse value by
definition; existence by continuity of $U$ in $\beta$: $p$ is continuous in
$\beta$ being a quotient of continuous sums, and the limits
$\beta \to \pm\infty$ reach the extreme energies $\min E\_i$ and $\max E\_i$;
tagged SUPPORTED with the limits computed explicitly in section 5; the
intermediate value theorem is the cited calculus premise).

## 5. The tilt is exactly the Gibbs distribution: rate = entropy deficit

Put the uniform measure as the reference, $p\_0 = (1/N, \dots, 1/N)$, the
largest-entropy point with no constraint ($H = \ln N$: the $N$-term sum of
$(1/N) \ln(1/N)$ telescopes to $\ln N$, shown one line:
$-\sum (1/N) \ln (1/N) = -\ln(1/N) = \ln N$ ). Now apply the exponential
tilt of case-large-deviations.md section 2 to the energy observable $E$ at
parameter $t$: $q\_t(i) = p\_0(i) e^{tE\_i}/Z(t)$,
$Z(t) = \sum\_i p\_0(i) e^{tE\_i}$. At $t = -\beta$, $q\_t = p\_\beta$, the
Gibbs state with $Z(-\beta) = Z(\beta)/N$ (because $Z(t)$ is the
$(1/N)$-normalized partition: $Z(t) = (1/N) \sum e^{tE\_i}$ and
$\sum e^{-\beta E\_i} = N Z(-\beta)$; section 2's normalization just
divides by $N$, stated).

Two evaluations of the same number. First, the relative entropy route:
$D(p\_\beta \ \parallel\  p\_0) = \sum\_i p\_i \ln(p\_i/(1/N)) = \ln N - H(p\_\beta)$.
Each term: $\ln(p\_i/(1/N)) = \ln p\_i + \ln N$; the first part gives $-H$,
the second gives $\ln N$ times $\sum p = \ln N$. Second, the tilt
identity: for $q\_t$ and $E\_t := \mathbb{E}\_{q\_t}[E]$:

$$
D(q\_t \ \parallel\  p\_0) = \sum q\_t(i)[tE\_i - \ln Z(t)] = t E\_t - \ln Z(t),
$$

where the bracket step is $\ln(q\_t/p\_0) = tE\_i - \ln Z(t)$ term by term.
At the matching $t^\*$ with $E\_{t^\*} = U$ (section 4's uniqueness), this
equals the Legendre sup of case-large-deviations.md section 2:

$$
t^\* U - \ln Z(t^\*) = \sup\_t [tU - \ln Z(t)] =: I(U).
$$

The sup form is the definition of the rate; the equality to the sup is the
Fenchel duality for convex $\ln Z$ (the course's favorite: for convex
maps, the Legendre transform evaluated as the tangent value; PROVEN there
for the stationary case and cited verbatim). Chaining the two
evaluations: $I(U) = \ln N - H(p\_\beta)$, where $\beta$ matches $U$. Both
sides nonnegative (match section 2 with $q = p$: $D \ge 0$; equivalently
$H \le \ln N$).

So Gibbs solves the rate problem AND the entropy problem simultaneously:
the most probable macrostate is the least information-destroying one
relative to the uniform baseline. PROVEN on the finite space, with the
Fenchel step cited from the large-deviations case.

## 6. Two-state example computed out loud

$E \in \lbrace-h, +h\rbrace$. $Z(\beta) = e^{\beta h} + e^{-\beta h}$ (sum over
the two states) $= 2 \cosh(\beta h)$ (definition of
$\cosh$: $(e^a + e^{-a})/2$, doubled). Mean energy:

$$
U = \sum\_i p\_i E\_i = (+h)\frac{e^{-\beta h}}{Z} + (-h)\frac{e^{\beta h}}{Z}
= h\frac{e^{-\beta h} - e^{\beta h}}{2 \cosh(\beta h)}
= -h \tanh(\beta h)
$$

(definition of $\tanh = \sinh/\cosh$; numerator is exactly
$-2 \sinh(\beta h)$ ). The ground state, energy $-h$, wins as $\beta$
grows: $p(\mathrm{ground}) = \frac{e^{\beta h}}{2 \cosh(\beta h)} \to 1$
as $\beta \to \infty$ since $e^{-2\beta h} \to 0$ (the same archimedean
limit as case-ewma.md section 3). PROVEN limits:

$\beta \to 0$: $Z \to 2$, $U \to 0$, $H \to \ln 2$ (uniform
distribution). $\beta \to \infty$: $U \to -h$, $H \to 0$ (the ground
state alone).

Entropy: $H = \beta U + \ln Z = -\beta h \tanh(\beta h) + \ln(2 \cosh(\beta h))$,
from section 3's identity. The free energy: $F := U - H/\beta$, defined so
that $F = -(1/\beta) \ln Z$ (one-line check:
$H/\beta = U + (\ln Z)/\beta$ ). This is the Legendre-conjugate face of the
same object: minimizing $F$ over $\beta$ picks the temperature at which
energetic preference and entropic spread balance.

## 7. Numeric fixtures, both routes shown

$\beta = 1$, $h = 1$. $Z = 2 \cosh 1 = 2 \cdot 1.5431 = 3.0862$
($\cosh 1$ computed as $(e + e^{-1})/2 = (2.7183 + 0.3679)/2$ ).
$p(\mathrm{ground}) = e/Z = 0.8808$,
$p(\mathrm{excited}) = 0.1192$. $U = -\tanh 1 = -0.7616$
($\tanh 1 = (e^1 - e^{-1})/(e^1 + e^{-1}) = 2.3504/3.0862 = 0.7616$ ).
Route one, direct entropy:

$$
H = -0.8808 \ln(0.8808) - 0.1192 \ln(0.1192)
= 0.8808 \cdot 0.1270 + 0.1192 \cdot 2.1269 = 0.1119 + 0.2534 = 0.3653.
$$

($\ln$ values from a table.) Route two, the identity:
$H = \beta U + \ln Z = -0.7616 + \ln(3.0862) = -0.7616 + 1.1269 = 0.3653$.
The two routes agree to four decimals, as proven. The rate reading:
$I(U) = \ln 2 - H = 0.6931 - 0.3653 = 0.3278$.

Cross-check through the lengthier Legendre machinery, so that this case
actually pays the Sanov debt: the tilted log-mgf of section 5 is
$\ln Z(t) = \ln(\cosh t)$ (since $(e^t + e^{-t})/2$ with the $(1/N)$
baseline $p\_0 = (1/2,1/2)$; $N = 2$, so $\ln Z(t) = \ln \cosh t$ ). The
matching condition gives $t^\*$ with $\tanh t^\* = U$, so
$t^\* = \mathrm{artanh}\  U = \mathrm{artanh}(-0.7616) = -1$, because
$\mathrm{artanh}$ is the inverse of $\tanh$ and $\tanh 1 = 0.7616$ by the
computation above. Then

$$
I(U) = t^\* U - \ln \cosh(t^\*) = (-1)(-0.7616) - \ln(\cosh 1)
= 0.7616 - \ln(1.5431) = 0.7616 - 0.4338 = 0.3278.
$$

Same rate. The $\mathrm{artanh}$ that appeared for the fair coin in
case-large-deviations.md section 4 appears again as the temperature.
SUPPORTED by the two independent computations, matching at four decimals.

## 8. Where the frontier is

- The free energy is convex-joint work; phase transitions are exactly
  points where $F$ per particle stops being analytic (Curie-Weiss, Ising;
  cited frontier about the thermodynamic limit).
- Sampling from Gibbs is the stationary problem of Markov chains
  (Metropolis acceptance = the tilt evaluated against a move); slow
  mixing at low temperature is the content of case-mixing.md.
- For continuous state spaces the same program runs on probability
  densities and the kinetic/entropy Lyapunov of case-h-theorem.md is the
  dynamical version: the $H$ quantity is minus your entropy, decaying.
- Maximum entropy as statistics: exponential families are Gibbs with
  $E\_i$ read as features; the two-state model above is logistic regression
  (the sigmoid is the ground-state occupation as a function of $\beta$).
  All cited as routes out of the finite-toy regime.
