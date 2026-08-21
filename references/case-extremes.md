# Case study: extreme values, or the wall the tilt cannot climb

This case starts where case-large-deviations.md section 7 and
case-gaertner-ellis.md section 8 pointed and builds the tool that
replaces the exponential tilt on the far side: block maxima and their
three limit laws. One example carries the whole method, plus the honest
map of what breaks and what replaces it.

## 1. The Cramér condition and its exact failure

The course's engine is the moment generating function. For a Pareto
claim size with tail P(Y > y) = (k/y)^alpha on y >= k (alpha > 0, k > 0),
density alpha k^alpha y^{-alpha-1} (the negative derivative of the
tail, one-line check), the mgf at ANY t > 0 is infinite. Proof: the
exponential series e^{ty} = sum_{N >= 0} (t y)^N/N! is a sum of
nonnegative terms, so it dominates any single term; choose N to
exceed alpha, then

E e^{tY} = integral_k^infty e^{ty} alpha k^alpha y^{-alpha-1} dy
>= (alpha k^alpha t^N/N!) integral_k^infty y^{N-alpha-1} dy = infinity

because the exponent N - alpha - 1 of the surviving power is above -1
(the integral of y^p over [k, infinity) diverges exactly at p >= -1,
the antiderivative written out). PROVEN pointwise: one term of one
series kills the transform. Consequences, named: Chernoff has no
exponent here (case-large-deviations.md section 2 needs M finite to
budget the tilt), the Lundberg adjustment equation has no root
(case-gaertner-ellis.md section 6 needs E e^{rY} < infinity), and on
this side of the wall the theory restarts around maxima, not sums.
This is the honest opening: first exhibit the wall, then build the
theory that lives behind it.

## 2. Block maxima: the exact distribution

M_n := max(Y_1..Y_n), Y_i i.i.d. with distribution F. The maximum is
at most u exactly when all n observations are at most u; independence
turns and into a product:

P(M_n <= u) = F(u)^n.  PROVEN: intersection formulation plus the
independence factorization, both named.

The whole extreme value program is the study of how F(u)^n behaves when
u grows with n so the product neither collapses to 0 nor freezes at 1.
The scales for the Pareto are computable by hand. Set u_n := k n^{1/alpha}:

P(Y > u_n) = (k/(k n^{1/alpha}))^alpha = 1/n (powers cancel term by
term, PROVEN arithmetic). Then for x > 0,

P(M_n <= u_n x) = (1 - P(Y > u_n x))^n = (1 - 1/(n x^alpha))^n
-> exp(-x^{-alpha}),

using the standard limit (1 - c/n)^n -> e^{-c}, justified by the log
series log(1 + z) = z + smaller terms at z = -c/n with remainder
O(1/n^2); the same series the course ran from case-ewma.md onward.
PROVEN up to that cited series. The nondegenerate limit is

G_alpha(x) = exp(-x^{-alpha}) on x > 0: the Fréchet distribution.

## 3. The three limit laws

Fisher-Tippett-Gnedenko (cited theorem, the classification the rest of
the case will use without re-proving): the only possible nondegenerate
limits of centered-scaled maxima are three families, and which one a
tail produces is decided by the tail itself.

1. Frechet (polar heavy tail): F has regularly varying tail of index
   -alpha; the Pareto above is the emblem and produces G_alpha.
2. Gumbel (thin or moderate tail): exponential or Gaussian tails; the
   exponential from case-gaertner-ellis.md section 6 is the emblem,
   centered at (ln n)/gamma with scale 1/gamma and limit exp(-e^{-x}).
3. Weibull (bounded support): the tail dies at a finite right endpoint
   r with a power surplus (r - y)^beta; the limit is exp(-(-x)^beta).

The Pareto example above computed its own centering u_n = k n^{1/alpha}
and scale; maximum domains require that the same centering works
uniformly, and for the Pareto it does (section 2's computation).

## 4. One fixture, fully computed

Take alpha = 2, k = 1. Then

u_n = n^{1/2}, and P(M_n <= n^{1/2} x) -> exp(-x^{-2}).

Return-level reading, both directions recomputed: the typical
maximum of n Pareto squares is around 1.201 n^{1/2}, because the median
of the Frechet limit solves exp(-x^{-2}) = 1/2, that is
-x^{-2} = ln(1/2) = -0.6931, x = 1/sqrt(0.6931) = 1.2011 (log table
arithmetic). Halved scales: P(M_n > (1/2) n^{1/2}) -> 1 - exp(-4)
= 1 - 0.0183 = 0.9817, since x = 1/2 gives -x^{-2} = -4: the maximum
clears half its typical scale almost always (the limit is exact, the
decimals from the exponential table, arithmetic PROVEN).
n = 10^6 makes u_n = 1000 exactly: the 10^6 observations' maximum is
medially around 1201, and clears 500 with limiting probability 0.9817.
SUPPORTED by the recomputed decimals against the closed forms.

## 5. Why thin tails need a different centering

Exponential claims, P(Y > y) = e^{-gamma y}, rate gamma (the case
of case-gaertner-ellis.md section 6): try the centering
c_n := (ln n)/gamma:

P(M_n <= c_n + x/gamma)
= (1 - exp(-gamma c_n - x))^n = (1 - e^{-x}/n)^n -> exp(-e^{-x}),

the Gumbel limit, the same (1 - c/n)^n engine as section 2 with
c = e^{-x} and a constant scale 1/gamma (the centering grows only
logarithmically because the tail already dies; the scale stays O(1)
because no power disputes it). PROVEN with the named limit. Contrast
the two orders in one line each: heavy tails center at n^{1/alpha}
(power), light tails at (ln n)/gamma (logarithm): the maximum of
exponential sizes grows as slowly as logarithms grow, a first honest
image of why tails decide extremes.

Gaussian tails sit in the same Gumbel class with centering
approximately sqrt(2 ln n) and the Mills-ratio corrections the course
already proved in case-large-deviations.md section 4 (cited; the
refinement exercise is the natural next fixture).

## 6. The two transfer principles, stated exactly

Block maxima put the three families in place; their domains that matter
in data are read off through two further engines, cited and not
re-proven:

1. Peak-over-threshold: exceedances beyond a high level u satisfy the
   generalized Pareto distribution asymptotically, F_u-type approx
   GPD(xi, sigma): the conditional tail of Y - u given Y > u. The
   same shape parameter xi carries the class: xi > 0 heavy, xi = 0
   Gumbel, xi < 0 Weibull (the sign convention converting between the
   two parameterizations). POT is the sample-efficient twin of block
   maxima (cited; complements rather than replaces section 2).
2. Von Mises conditions: differentiability of the reciprocal hazard
   in the right tail decides the domain of attraction; for the Pareto
   and exponential emblems the conditions reduce to one-line limits
   read from the densities computed in this file (cited; the checks
   are exercises).

The reason the folder title says tail risk: capital measures that
condition on the extreme right (reinsurance layers, value at risk at
high confidence) are EXACTLY parameters of GPD, which is why
case-gaertner-ellis.md section 8 parked ruin theory at the wall this
case climbs.

## 7. Where the frontier is

- Regular variation and Karamata theory: the slow (power) variation
  calculus that runs Frechet centering in general maximization domains
  (cited; the n^{1/alpha} computation above is the emblem case).
- Multivariate and spatial extremes: maxima of fields need stable
  exponent-measures on cones rather than single laws (cited).
- Clustering of extremes: time series produce bursts of exceedances and
  the extremal index corrects the independence factorization of
  section 2 (cited) - the memory step that mirrors what Gärtner-Ellis
  did for sums in case-gaertner-ellis.md section 8.
