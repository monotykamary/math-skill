# Case study: the Kalman filter is Gaussian conditioning, and the EWMA is its fixed-point shadow

Estimation case #1, and the one that closes the loop started in
case-ewma.md. The heat accumulator there was a recursion with a retention
factor. Here the same recursion appears at the end of a longer derivation:
every measurement updates a Gaussian belief, and the optimal update is
computed, not guessed. Every step shown; every formula checked.

## 1. The model

A hidden scalar state $x$ drives a stream of measurements. The state does
not move in the first part: $x$ is fixed but unknown, drawn once from a
prior $N(m\_0, P\_0)$. At each turn $k$ an instrument returns
$z\_k = x + v\_k$, with $v\_k$ independent $N(0, R)$ noise.

The readings are conditionally independent given $x$ (each $v\_k$ is
independent; stated, so the likelihood factorizes). The task: update the
belief over $x$ after each reading. Belief, not point estimate: a mean and
a variance, carried together.

## 2. One Bayesian update, completely

Prior on $x$: density $p(x) = (2\pi P)^{-1/2} \exp(-(x-m)^2/(2P))$. A new
reading $z$ has likelihood density
$L(x) = (2\pi R)^{-1/2} \exp(-(z-x)^2/(2R))$. Bayes: posterior density is
proportional to the product $p(x) L(x)$ (the normalizing constant is fixed
by the requirement that a density integrates to 1, and renormalizing does
not change where the mass lies). Only the exponent needs work:
$E(x) := (x-m)^2/(2P) + (z-x)^2/(2R)$. Expand both squares term by term:

$$
E(x) = \frac{x^2 - 2mx + m^2}{2P} + \frac{z^2 - 2zx + x^2}{2R}
$$

multiply through by $2PR$ ($PR$ is positive, so this changes nothing about
the minimizer):

$$
2PR\  E(x) = R(x^2 - 2mx + m^2) + P(z^2 - 2zx + x^2)
= (R+P) x^2 - 2(Rm + Pz) x + (Rm^2 + Pz^2).
$$

The exponent of a Gaussian $N(m', P')$ has the form
$-F(x) = -(x-m')^2/(2P') + \text{constant}$. Match the two top
coefficients:

$(R+P) x^2$ with $(x^2)/(2P')$: the $x^2$ coefficient is $1/(2P')$, so
$1/P' = (R+P)/(PR) = 1/R + 1/P$. The $x$ coefficient is
$-2(Rm+Pz)/(2PR) = -(Rm+Pz)/(PR)$, matching
$-2m'/(2P') = -m'/P'$: $m'/P' = (Rm+Pz)/(PR)$, and with
$1/P' = (R+P)/(PR)$:

$$
m' = (P'/(PR))(Rm + Pz) = (Rm + Pz)/(R+P).
$$

Define the gain $K := P/(P+R)$. Then $P' = PR/(P+R)$ and

$$
m' = (R/(R+P)) m + (P/(R+P)) z = (1-K) m + K z, \qquad
P' = P R/(P+R) = (1-K) P.
$$

Status: PROVEN by completing the square. Note the two loads: the mean
moves toward the reading by a fraction $K$ of the error $(z - m)$, and the
variance shrinks by the factor $(1-K) = R/(P+R)$. Precisions add: the
inverse-variance update is the additive one, not the variance update.
This is the entire content of Gaussian conditioning in one formula pair.

The numeric fixture for this section lives in section 6.

## 3. Iterating with no motion: closed form

From $P$ after $k$ readings, call it $P\_k$, the next update is
$P\_{k+1} = P\_k R/(P\_k + R)$. This looks nonlinear. Invert it:
$1/P\_{k+1} = (P\_k + R)/(P\_k R) = 1/R + 1/P\_k$. Set $Q\_k := 1/P\_k$
(precision). Then $Q\_{k+1} = Q\_k + 1/R$, plainly additive, so
$Q\_k = Q\_0 + k/R$ and

$$
P\_k = P\_0 R/(R + k P\_0). \qquad \text{(closed form, no motion)}
$$

Status: PROVEN. The step $Q\_{k+1} = Q\_k + 1/R$ is the recursion moved from
variance to precision; the closed form is one induction away and the
induction was shown in full for the same shape in case-ewma.md section 2.

Two consequences, each with its justification:

1. Error variance decays like $1/k$: for any fixed $P\_0$, $R$, the ratio
   $P\_k / (R/k) = k P\_0/(R + k P\_0)$ tends to 1 as $k$ grows (divide
   numerator and denominator by $k$). So $P\_k \sim R/k$ asymptotically.
   PROVEN limit; the constant $R/k$ is exactly the variance of the sample
   mean of $k$ independent $N(0, R)$ readings, recalling
   $\mathrm{Var}(\text{average}) = R/k$.
2. The gain also decays:
   $K\_k = P\_k/(P\_k + R) = P\_0/(R + (k+1)P\_0)$. (Substitute the closed
   form into $P/(P+R)$; the algebra: with $P = P\_0R/(R+kP\_0)$,
   $P + R = R(P\_0 + R + kP\_0)/(R+kP\_0)$, and the ratio cancels to
   $P\_0/(R+(k+1)P\_0)$.) PROVEN.

## 4. Motion and process noise: the Riccati map

Now let the state drift: $x\_{k+1} = x\_k + w\_k$ with independent
$w\_k \sim N(0, Q)$, and the reading still $z\_k = x\_k + v\_k$. The belief
does two things per turn. Predict: with no new reading, adding noise of
variance $Q$ to a Gaussian of variance $P\_k$ gives variance $P\_k + Q$
(variances add for independent terms, as in case-black-scholes.md
section 1). Update: section 2 applies with the predicted variance.
Composing:

$$
P\_{k+1} = R (P\_k + Q) / (P\_k + Q + R) =: F(P\_k).
$$

Status of the composition: PROVEN by sections 1 and 2; $F$ is the scalar
Riccati map. Two claims about $F$, both proven here.

Claim A (fixed point). A fixed point solves $P = R(P+Q)/(P+Q+R)$.
Multiply by $P+Q+R$ (positive, no sign change): $P(P+Q+R) = R(P+Q)$,
expand $P^2 + P(Q+R) = RP + RQ$, cancel $RP$ from both sides (subtract
$RP$): $P^2 + PQ = RQ$, so $P^2 + QP - RQ = 0$. The quadratic formula
(derived by completing the square, the same move as section 2) gives one
positive root:

$$
P^\* = (-Q + \sqrt{Q^2 + 4QR})/2.
$$

The other root is negative, since the product of roots is $-RQ < 0$ (a
property of $x^2 + Qx - RQ$: the constant term). Positive because
$P^\* = \sqrt{Q^2+4QR}/2 - Q/2$ and $\sqrt{Q^2+4QR} > Q$ when $R > 0$.
Status: PROVEN.

Claim B (convergence). $F$ is increasing and weakly contractive:
$F'(P) = R^2/(P+Q+R)^2$, by the quotient rule on $R(P+Q)/(P+Q+R)$ with
numerator derivative $R$ and denominator derivative 1. Now
$R^2/(P+Q+R)^2 < 1$ because $P+Q+R > R > 0$ (all variances positive), so
on any compact interval the map shortens distances (mean value theorem:
distance between images is at most the sup of the derivative times the
distance). Starting from $P\_0$, the sequence $P\_k$ stays in the compact
interval $[0, P\_0 + Q]$ (each step is an average:
$P\_{k+1} = R(P\_k+Q)/(P\_k+Q+R)$ lies between 0 and $P\_k + Q$ because
$R/(P\_k+Q+R) < 1$ ). A sequence in a compact interval whose steps are
contractions has a limit, and the limit is a fixed point because $F$ is
continuous and $P\_{k+1} - F(P\_k) = 0$ passed to the limit. Status: PROVEN.

## 5. The surprise fixture: Q = R = 1

Then $F(P) = (P+1)/(P+2)$. Iterate from $P\_0 = 1$ (turn zero has no
reading yet, $P\_0$ is the prior variance):

$$
P\_1 = 2/3, \quad P\_2 = (5/3)/(8/3) = 5/8, \quad
P\_3 = (13/8)/(21/8) = 13/21, \quad P\_4 = (34/21)/(55/21) = 34/55.
$$

The numerators and denominators are Fibonacci numbers: 2,3,5,8,13,21,34,55.
Formalize it. Claim: $P\_k = F\_{2k+1}/F\_{2k+2}$ for $k$ at least 1, where
$F\_1 = F\_2 = 1$, $F\_{n+2} = F\_{n+1} + F\_n$. Proof by induction. Base $k=1$:
$F\_3/F\_4 = 2/3 = P\_1$. Step: if $P\_k = F\_{2k+1}/F\_{2k+2} = a/b$, then
$F(P\_k) = (a+b)/(a+2b)$. By the Fibonacci recursion
$a+b = F\_{2k+2}+F\_{2k+1} = F\_{2k+3}$, and
$a+2b = F\_{2k+1}+2F\_{2k+2} = F\_{2k+1}+F\_{2k+2}+F\_{2k+2} = F\_{2k+3} + F\_{2k+2} = F\_{2k+4}$
(apply the recursion twice, each use named). Status: PROVEN.

The limit: by Binet
($F\_n = (\varphi^n - (-\varphi)^{-n})/\sqrt{5}$, derived from the
characteristic roots of the Fibonacci recursion, and the subtraction term
decays because $\varphi = 1.618\dots > 1$, so
$F\_n \sim \varphi^n/\sqrt{5}$),

$$
P\_k \to 1/\varphi = (\sqrt{5}-1)/2 \approx 0.618.
$$

And section 4 predicts exactly this: with $Q = R = 1$,
$P^\* = (-1+\sqrt{5})/2$. Two independent computations, one through the
golden ratio, one through the quadratic formula. They agree, as proven.

## 6. Where the EWMA fits

The EWMA of case-ewma.md updates $W\_{k+1} = (1-\rho) s\_{k+1} + \rho W\_k$.
Section 2's Bayesian update is $m' = K z + (1-K) m$. Same recursion with
$K = 1 - \rho$ and reading $z$ in the role of score $s$. So the heat
accumulator is exactly a $\text{one-}z$ value Gaussian belief update with a frozen
gain. The production system chose $\tau = 2$, hence gain
$K = 1 - \rho = 1 - (1 - 1/\tau) = 1/\tau = 1/2$.

When is a frozen gain the right move? With no drift ($Q = 0$, section 3)
the optimal gain decays as $1/(k+1)$, so any fixed gain underestimates the
confidence a long run gives. With drift, the optimal gain tends to the
Riccati fixed point $K^\* = P^\*/(P^\*+R)$, and the EWMA with retention
$\rho = 1 - K^\*$ is the stateless approximation to optimal tracking. The
production heat has a human-tuned retention in place of a Riccati
equation: the design question, now stated, is what $Q$ and $R$ the
threshold system implicitly assumes.

## 7. Falsifiable checks

- $P\_0 = R = 1$, no motion: the closed form gives $P\_k = 1/(k+1)$.
  Compute from the recursion: $P\_1 = 1/2$, $P\_2 = (1/2)/(3/2) = 1/3$.
  From the formula: $1/(1+k)$. Both agree for $k = 1, 2$. SUPPORTED, and
  in fact PROVEN through the precision induction.
- Motion fixture above: Fibonacci numerators and denominators up to
  $34/55$ at $k = 4$, hand-computed from the map. SUPPORTED.
- Two readings, no prior: let $P\_0$ grow (an arbitrarily diffuse prior).
  Then $K\_1 = P\_0/(R+P\_0) \to 1$ and $K\_2 = P\_0/(R+2P\_0) \to 1/2$.
  Hence $m\_1 \to z\_1$ and
  $m\_2 \to z\_1 + (1/2)(z\_2 - z\_1) = (z\_1+z\_2)/2$: the sample mean. The
  filter with no motion converges to complete averaging. PROVEN limit,
  matching check 1's asymptotic.
- Tilt link: the posterior of section 2 reweights the prior by the
  likelihood, an exponential tilt $e^{(z-x)^2\text{ stuff}}$. The same
  tilt appears in case-large-deviations.md section 2. Sanity limit:
  reading infinitely confident, $R \to 0$, then $K \to 1$, the mean jumps
  to $z$ and the variance to 0. Correct: a noiseless reading reveals $x$
  exactly. PROVEN limit.

## 8. Where the frontier is

- Vector states need matrix Riccati equations; the scalar completion of
  squares becomes a matrix identity, and statements need orderings of
  positive semidefinite covariance. Cited.
- Nonlinear dynamics kill completed squares. The extended and unscented
  filters linearize; particle filters drop parametric form and represent
  the belief by samples, reweighted by exactly the likelihood (ancestor
  of the Gibbs tilt of case-gibbs.md). Cited.
- Non-Gaussian heavy tails return: case-extremes.md shows what filtering
  faces when the large-deviations mgf of case-large-deviations.md
  section 7 does not exist.

The unrestricted gain-complement statement remains open in
`lean/Frontier/Conjectures.lean`. `bend/OPEN.md` records the signed-division
work needed to close its Bend counterpart.
