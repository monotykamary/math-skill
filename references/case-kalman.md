# Case study: the Kalman filter is Gaussian conditioning, and the EWMA is its fixed-point shadow

Estimation case #1, and the one that closes the loop started in
case-ewma.md. The heat accumulator there was a recursion with a retention
factor. Here the same recursion appears at the end of a longer derivation:
every measurement updates a Gaussian belief, and the optimal update is
computed, not guessed. Every step shown; every formula checked.

## 1. The model

A hidden scalar state x drives a stream of measurements. The state does
not move in the first part: x is fixed but unknown, drawn once from a
prior N(m_0, P_0). At each turn k an instrument returns

z_k = x + v_k, with v_k independent N(0, R) noise.

The readings are conditionally independent given x (each v_k is
independent; stated, so the likelihood factorizes). The task: update the
belief over x after each reading. Belief, not point estimate: a mean and
a variance, carried together.

## 2. One Bayesian update, completely

Prior on x: density p(x) = (2 pi P)^(-1/2) exp(-(x-m)^2 / (2P)). A new
reading z has likelihood density L(x) = (2 pi R)^(-1/2) exp(-(z-x)^2 / (2R)).
Bayes: posterior density is proportional to the product p(x) L(x)
(the normalizing constant is fixed by the requirement that a density
integrates to 1, and renormalizing does not change where the mass lies).
Only the exponent needs work:

E(x) := (x-m)^2 / (2P) + (z-x)^2 / (2R).

Expand both squares term by term:

E(x) = (x^2 - 2mx + m^2) / (2P) + (z^2 - 2zx + x^2) / (2R)

multiply through by 2PR (PR is positive, so this changes nothing about
the minimizer):

2PR E(x) = R(x^2 - 2mx + m^2) + P(z^2 - 2zx + x^2)
         = (R+P) x^2 - 2(Rm + Pz) x + (Rm^2 + Pz^2).

The exponent of a Gaussian N(m', P') has the form
-F(x) = -(x-m')^2/(2P') + constant. Match the two top coefficients:

(R+P) x^2 with (x^2)/(2P'): the x^2 coefficient is 1/(2P'), so
1/P' = (R+P)/(PR) = 1/R + 1/P.

The x coefficient is -2(Rm+Pz)/(2PR) = -(Rm+Pz)/(PR), matching
-2m'/(2P') = -m'/P': m'/P' = (Rm+Pz)/(PR), and with 1/P' = (R+P)/(PR):

m' = (P'/(PR))(Rm + Pz) = (Rm + Pz)/(R+P).

Define the gain K := P/(P+R). Then P' = PR/(P+R) and

m' = (R/(R+P)) m + (P/(R+P)) z = (1-K) m + K z,
P' = P R/(P+R) = (1-K) P.

Status: PROVEN by completing the square. Note the two loads: the mean
moves toward the reading by a fraction K of the error (z - m), and the
variance shrinks by the factor (1-K) = R/(P+R). Precisions add: the
inverse-variance update is the additive one, not the variance update.
This is the entire content of Gaussian conditioning in one formula pair.

The numeric fixture for this section lives in section 6.

## 3. Iterating with no motion: closed form

From P after k readings, call it P_k, the next update is
P_(k+1) = P_k R/(P_k + R). This looks nonlinear. Invert it:

1/P_(k+1) = (P_k + R)/(P_k R) = 1/R + 1/P_k.

Set Q_k := 1/P_k (precision). Then Q_(k+1) = Q_k + 1/R, plainly additive,
so Q_k = Q_0 + k/R and

P_k = P_0 R/(R + k P_0).     (closed form, no motion)

Status: PROVEN. The step Q_(k+1) = Q_k + 1/R is the recursion moved from
variance to precision; the closed form is one induction away and the
induction was shown in full for the same shape in case-ewma.md section 2.

Two consequences, each with its justification:

1. Error variance decays like 1/k: for any fixed P_0, R, the ratio
   P_k / (R/k) = k P_0/(R + k P_0) tends to 1 as k grows (divide
   numerator and denominator by k). So P_k ~ R/k asymptotically. PROVEN
   limit; the constant R/k is exactly the variance of the sample mean of
   k independent N(0, R) readings, recalling Var(average) = R/k.

2. The gain also decays: K_k = P_k/(P_k + R) = P_0/(R + (k+1)P_0).
   (Substitute the closed form into P/(P+R); the algebra: with
   P = P_0R/(R+kP_0), P + R = R(P_0 + R + kP_0)/(R+kP_0), and the ratio
   cancels to P_0/(R+(k+1)P_0).) PROVEN.

## 4. Motion and process noise: the Riccati map

Now let the state drift: x_(k+1) = x_k + w_k with independent w_k ~ N(0, Q),
and the reading still z_k = x_k + v_k. The belief does two things per turn.
Predict: with no new reading, adding noise of variance Q to a Gaussian of
variance P_k gives variance P_k + Q (variances add for independent terms,
as in case-black-scholes.md section 1). Update: section 2 applies with the
predicted variance. Composing:

P_(k+1) = R (P_k + Q) / (P_k + Q + R) =: F(P_k).

Status of the composition: PROVEN by sections 1 and 2; F is the scalar
Riccati map. Two claims about F, both proven here.

Claim A (fixed point). A fixed point solves P = R(P+Q)/(P+Q+R).
Multiply by P+Q+R (positive, no sign change):
P(P+Q+R) = R(P+Q), expand P^2 + P(Q+R) = RP + RQ, cancel RP from both
sides (subtract RP): P^2 + PQ = RQ, so P^2 + QP - RQ = 0. The quadratic
formula (derived by completing the square, the same move as section 2)
gives one positive root:

P* = (-Q + sqrt(Q^2 + 4QR)) / 2.

The other root is negative, since the product of roots is -RQ < 0 (a
property of x^2 + Qx - RQ: the constant term). Positive because
P* = sqrt(Q^2+4QR)/2 - Q/2 and sqrt(Q^2+4QR) > Q when R > 0.
Status: PROVEN.

Claim B (convergence). F is increasing and weakly contractive:
F'(P) = R^2/(P+Q+R)^2, by the quotient rule on R(P+Q)/(P+Q+R) with
numerator derivative R and denominator derivative 1. Now
R^2/(P+Q+R)^2 < 1 because P+Q+R > R > 0 (all variances positive), so on
any compact interval the map shortens distances (mean value theorem:
distance between images is at most the sup of the derivative times the
distance). Starting from P_0, the sequence P_k stays in the compact
interval [0, P_0 + Q] (each step is an average: P_(k+1) = R(P_k+Q)/(P_k+Q+R)
lies between 0 and P_k + Q because R/(P_k+Q+R) < 1). A sequence in a
compact interval whose steps are contractions has a limit, and the limit
is a fixed point because F is continuous and P_(k+1) - F(P_k) = 0 passed
to the limit. Status: PROVEN.

## 5. The surprise fixture: Q = R = 1

Then F(P) = (P+1)/(P+2). Iterate from P_0 = 1 (turn zero has no reading
yet, P_0 is the prior variance):

P_1 = 2/3, P_2 = (5/3)/(8/3) = 5/8, P_3 = (13/8)/(21/8) = 13/21,
P_4 = (34/21)/(55/21) = 34/55.

The numerators and denominators are Fibonacci numbers: 2,3,5,8,13,21,34,55.
Formalize it. Claim: P_k = F_{2k+1}/F_{2k+2} for k at least 1, where
F_1 = F_2 = 1, F_(n+2) = F_(n+1) + F_n. Proof by induction. Base k=1:
F_3/F_4 = 2/3 = P_1. Step: if P_k = F_{2k+1}/F_{2k+2} = a/b, then
F(P_k) = (a+b)/(a+2b). By the Fibonacci recursion a+b = F_{2k+2}+F_{2k+1}
= F_{2k+3}, and a+2b = F_{2k+1}+2F_{2k+2} = F_{2k+1}+F_{2k+2}+F_{2k+2}
= F_{2k+3} + F_{2k+2} = F_{2k+4} (apply the recursion twice, each use
named). Status: PROVEN.

The limit: by Binet (F_n = (phi^n - (-phi)^(-n))/sqrt(5), derived from
the characteristic roots of the Fibonacci recursion, and the subtraction
term decays because phi = 1.618... > 1, so F_n ~ phi^n/sqrt(5)),

P_k -> 1/phi = (sqrt(5)-1)/2 ~ 0.618.

And section 4 predicts exactly this: with Q = R = 1, P* = (-1+sqrt(5))/2.
Two independent computations, one through the golden ratio, one through
the quadratic formula. They agree, as proven.

## 6. Where the EWMA fits

The EWMA of case-ewma.md updates W_(k+1) = (1-rho) s_(k+1) + rho W_k.
Section 2's Bayesian update is m' = K z + (1-K) m. Same recursion with
K = 1 - rho and reading z in the role of score s. So the heat
accumulator is exactly a one-z-value Gaussian belief update with a frozen
gain. The production system chose tau = 2, hence gain K = 1 - rho
= 1 - (1 - 1/tau) = 1/tau = 1/2.

When is a frozen gain the right move? With no drift (Q = 0, section 3)
the optimal gain decays as 1/(k+1), so any fixed gain underestimates the
confidence a long run gives. With drift, the optimal gain tends to the
Riccati fixed point K* = P*/(P*+R), and the EWMA with retention
rho = 1 - K* is the stateless approximation to optimal tracking. The
production heat has a human-tuned retention in place of a Riccati
equation: the design question, now stated, is what Q and R the threshold
system implicitly assumes.

## 7. Falsifiable checks

- P_0 = R = 1, no motion: the closed form gives P_k = 1/(k+1).
  Compute from the recursion: P_1 = 1/2, P_2 = (1/2)/(3/2) = 1/3.
  From the formula: 1/(1+k). Both agree for k = 1, 2. SUPPORTED, and in
  fact PROVEN through the precision induction.
- Motion fixture above: Fibonacci numerators and denominators up to
  34/55 at k = 4, hand-computed from the map. SUPPORTED.
- Two readings, no prior: let P_0 grow (an arbitrarily diffuse prior).
  Then K_1 = P_0/(R+P_0) -> 1 and K_2 = P_0/(R+2P_0) -> 1/2. Hence
  m_1 -> z_1 and m_2 -> z_1 + (1/2)(z_2 - z_1) = (z_1+z_2)/2: the
  sample mean. The filter with no motion converges to complete averaging.
  PROVEN limit, matching check 1's asymptotic.
- Tilt link: the posterior of section 2 reweights the prior by the
  likelihood, an exponential tilt e^{(z-x)^2 stuff}. The same tilt
  appears in case-large-deviations.md section 2. Sanity limit: reading
  infinitely confident, R -> 0, then K -> 1, the mean jumps to z and the
  variance to 0. Correct: a noiseless reading reveals x exactly. PROVEN
  limit.

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

Conjectures tied to this case live in lean/Frontier/Conjectures.lean.