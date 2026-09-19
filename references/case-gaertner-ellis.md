# Case study: thresholds with memory, and the ruin exponent

The production question case-ewma.md asked (when does the heat cross theta)
had deterministic input. Real input is random. This file does two honest
things. First: for an EWMA fed by random scores, the chain's exact
log-moment generating function, found through a self-similarity fixed
point, and the Gaussian rate that follows. Second: the actuarial twin of
the same question (Cramér-Lundberg ruin), where the same exponential tilt
bounds the probability a surplus line ever dies. Every cancellation is
named.

## 1. The random EWMA, restated

Scores $s\_1, s\_2, \dots$ are i.i.d., mean 0, variance $\sigma^2$, mgf
$m(t) = \mathbb{E} e^{t s}$. The heat $W\_n$ updates as in case-ewma.md:
$W\_{n+1} = (1-\rho) s\_{n+1} + \rho W\_n$. The target event:
$W\_n \ge \theta$ for some threshold. Question one: the rate at which the
stationary heat sits above $\theta$. Question two: how close the
finite-time heat is to stationary before we may use that rate.

Mean 0 keeps $W\_n$ mean 0 at every $n$; the threshold asks for an
upper-deck event, whose exponential cost the large-deviations case
measures.

## 2. Two computations that locate the stationary law

Claim 1: the lag-one autocorrelation of the stationary EWMA is $\rho$.
Index the stationary sequence on the negative integers so that the
latest score reads $s\_0$ and $W^\* := (1-\rho) \sum\_{j \ge 0} \rho^j s\_{-j}$:
the doubly indexed past, a well-defined stationary object because the
sequence is i.i.d. and doubly infinite in the stationarity construction.
The one-step shift is $W^\*\_1 := (1-\rho) \sum\_{j \ge 0} \rho^j s\_{1-j}$.
Covariance:

$$
\mathrm{Cov}(W^\*, W^\*\_1) = (1-\rho)^2 \sum\_{j \ge 1} \rho^j \rho^{j-1} \sigma^2
$$

because the terms with a common index are exactly those with
$-j = 1 - j'$, that is $j' = j - 1$, and $j$ runs from 1 upward; distinct
index pairs contribute 0 by independence (named premise, the same Cov
expansion as case-black-scholes.md section 1). Pull the factor:

$$
\begin{aligned}
\mathrm{Cov} &= (1-\rho)^2 \sigma^2 \rho^{-1} \sum\_{j \ge 1} \rho^{2j}
= (1-\rho)^2 \sigma^2 \rho \sum\_{j \ge 0} \rho^{2j} \\
&= (1-\rho)^2 \sigma^2 \rho / (1-\rho^2)
= \sigma^2 \rho (1-\rho)/(1+\rho).
\end{aligned}
$$

The geometric identity $\sum\_{j \ge 0} \rho^j = 1/(1-\rho)$ proved in
case-ewma.md section 2 was applied at $\rho^2$, giving $1/(1-\rho^2)$,
and $(1-\rho^2) = (1-\rho)(1+\rho)$ was factored. Dividing by
$\mathrm{Var}(W^\*) = \sigma^2 (1-\rho)/(1+\rho)$ (Claim 2 below) gives
exactly $\rho$. PROVEN.

Claim 2: $\mathrm{Var}(W^\*) = \sigma^2 (1-\rho)/(1+\rho)$. Independence makes
the variance additive across $j$ (covariances across distinct $j$ vanish,
justified exactly as in case-black-scholes.md section 1), giving
$(1-\rho)^2 \sigma^2 \sum\_{j \ge 0} \rho^{2j} = (1-\rho)^2 \sigma^2/(1-\rho^2) = \sigma^2 (1-\rho)/(1+\rho)$,
dividing numerator and denominator by $(1-\rho)$ (nonzero since $\rho < 1$)
where $(1-\rho^2) = (1-\rho)(1+\rho)$. PROVEN.

## 3. The exact log-mgf from self-similarity

$W^\* = (1-\rho) s\_0 + \rho$ (the same series from $j = 1$ scaled), and that
remainder is independent of $s\_0$ (the sets of indices $\lbrace0\rbrace$ and
$\lbrace1,2,\dots\rbrace$ are disjoint, and independence of the i.i.d. sequence
is the named premise) with the same law as $W^\*$ (stationarity of the backward
shift). Hence $M(t) := \mathbb{E} e^{tW^\*}$ satisfies
$M(t) = \mathbb{E} e^{t(1-\rho)s\_0} \  \mathbb{E} e^{t \rho W^\*} = m((1-\rho) t) M(\rho t)$.
This fixed-point identity is PROVEN from the series representation. Iterate $J$
times (each application shifts the backward sum one more place;
$\rho \rho \rho$ compounds as $\rho^J$):

$$
M(t) = \Bigl[\prod\_{j = 0}^{J-1} m((1-\rho) \rho^j t)\Bigr] M(\rho^J t).
$$

$M$ is continuous at 0 with $M(0)=1$ by dominated convergence at 0
(bounded by $e^{\text{something}}$ near 0 since
$m(t) = 1+\sigma^2 t^2/2+o(t^2)$, the mgf expansion, cited from
case-large-deviations.md), and $\rho^J t \to 0$ (archimedean limit of
case-ewma.md). Taking $J \to \infty$:

$$
\log M(t) = \sum\_{j \ge 0} \log m((1-\rho) \rho^j t) =: \Lambda(t).
$$

Status: PROVEN for Gaussian scores below, where the sum evaluates to a
closed form; the general convergence step sits on the mgf expansion and
the geometric decay of $\rho^j$, and is tagged GAP for the non-Gaussian
tail of the argument (Gärtner-Ellis handles it; cited below).

## 4. Gaussian scores close the sum

$m(u) = \exp(\sigma^2 u^2/2)$: the completion of squares inside the
Gaussian integral of case-large-deviations.md section 4, where the whole
derivation appears. Then $\log m(u) = \sigma^2 u^2/2$ and the geometric
identity gives

$$
\begin{aligned}
\Lambda(t) &= (\sigma^2 t^2/2)(1-\rho)^2 \sum\_{j \ge 0} \rho^{2j}
= \sigma^2 t^2 (1-\rho)^2 / (2 (1-\rho^2)) \\
&= \sigma^2 t^2 (1-\rho) / (2 (1+\rho)),
\end{aligned}
$$

each factor justified above. $\Lambda$ is a pure quadratic, so
$\exp(\Lambda(t))$ is exactly the mgf of a centered Gaussian of
variance $V = \sigma^2 (1-\rho)/(1+\rho)$. The mgf determines the
distribution (Laplace inversion, cited from case-large-deviations.md
section 4): the stationary heat $W^\*$ is exactly Gaussian with variance
$V$, matching Claim 2 of section 2 by two routes. PROVEN.

The Chernoff rate: $I(\theta) = \sup\_{t \ge 0} [t \theta - \Lambda(t)]$.
The sup of a concave quadratic attains at the peak $t^\* = \theta/V$ (the
same peak algebra as case-large-deviations.md section 4: derivative
$\theta - V t$ zeroed), value $\theta^2/(2V)$. Because $W^\*$ is a true
Gaussian, the Mills ratio of case-large-deviations.md section 4 turns the
Chernoff bound into the same exponent the true tail carries:
$\log \mathbb{P}(W^\* \ge \theta) = -\theta^2/(2V) + O\text{-ish log correction}$:
the rate function equals the Gaussian exponent
$\theta^2/(2V) = \theta^2/(2 \sigma^2) \cdot (1+\rho)/(1-\rho)$. Sanity
limits, each proven from the formula: $\rho \to 0$ recovers
$V = \sigma^2$ and the plain i.i.d. rate; $\rho \to 1$ forces
$V \to \infty$ and the rate $\to 0$ (a memory that never decays dilutes
no off-peak event).

Fixture $\sigma = 1$, $\rho = 1/2$, $\theta = 0.7$:
$V = (1-1/2)/(1+1/2) = 1/3$. Rate $= \theta^2/(2V) = 0.49/(2/3) = 0.735$.
Chernoff bound $\exp(-0.735) = 0.4795$ by log tables. True Gaussian tail:
$1 - \Phi(\theta/\sqrt{V}) = 1 - \Phi(1.2124) = 0.1127$ ($\Phi$ table,
1.21 interpolated). The bound overstates by a factor near 4 at this
moderate $\theta$, exactly as the Chernoff-versus-Chebyshev contrast in
case-large-deviations.md section 5 promised at moderate scales. The two
exponents, not pre-exponential constants, agree; this is
logarithmic equivalence, the parity of large deviations.

## 5. Finite-time heat and its approach to stationary

The unrolled finite heat from zero start (the closed form of
case-ewma.md section 2 with inputs, unrolled and telescoped back):

$$
W\_n = (1-\rho) \sum\_{j=0}^{n-1} \rho^j s\_{n-j}.
$$

(Proof: induction; the step is the recursion with the inner sum shifted;
each index handled once.) The stationary tail difference is
$W^\* - W\_n = (1-\rho) \sum\_{j \ge n} \rho^j s\_{\dots}$. Variance gap:

$$
\mathrm{Var}(W^\* - W\_n) = \sigma^2 (1-\rho)^2 \sum\_{j \ge n} \rho^{2j}
= \sigma^2 \rho^{2n} (1-\rho)/(1+\rho),
$$

the geometric tail sum $\rho^{2n}/(1-\rho^2)$, times the prefactor;
PROVEN by the identical additivity. So the distance to stationarity
decays like $\rho^{2n}$: for $\rho = 1/2$ the variance gap decays by a
factor of 4 each turn. After $n = 9$ turns, factor
$4^{-9} \sim 2.6 \cdot 10^{-6}$: the stationary rate of section 4 is
usable for the production threshold question within a handful of turns,
and this variance bound PROVES the hand-waving rather than assuming it.

## 6. The twin question in insurance: Cramér-Lundberg

An insurer receives claims of random size $Y$ at the jump times of a Poisson
process with rate $\lambda$. $Y\_i$ are i.i.d. $\mathrm{Exp}(\gamma)$: density
$\gamma e^{-\gamma y}$, mean $1/\gamma$, mgf
$\mathbb{E} e^{rY} = \gamma/(\gamma-r)$ for $r < \gamma$ (computed by direct
integration:
$\int\_0^\infty \gamma e^{-\gamma y} e^{r y} \  dy = \gamma \int e^{-(\gamma-r)y} \  dy = \gamma/(\gamma-r)$;
each step named). Premium income flows at rate $c$. Surplus:
$X\_t = u + c t - \sum\_{i \le N\_t} Y\_i$, where $N\_t$ is the Poisson count. Ruin
time $T = \inf\lbracet : X\_t < 0\rbrace$; ruin probability
$\psi(u) = \mathbb{P}(T < \infty)$.

The adjustment equation: find $r^\* > 0$ with
$\lambda(\mathbb{E} e^{r^\*Y} - 1) = c r^\*$. For exponential claims
$\mathbb{E} e^{rY} - 1 = \gamma/(\gamma-r) - 1 = r/(\gamma-r)$ (fraction
subtractions, the $(\gamma-r)/(\gamma-r)$ common denominator spell).
Since $r > 0$, divide both sides by $r$: $\lambda/(\gamma-r) = c$, hence
$r^\* = \gamma - \lambda/c$. Positive exactly when $c > \lambda/\gamma$, the
premium calling itself the safety loading: premium exceeds expected
claim outflow (mean claim rate $\lambda \times$ mean claim $1/\gamma$).
PROVEN algebra, fully written.

Martingale step: $M\_t := \exp(-r^\* X\_t)$. The increment over $(t, t+u]$:

$$
\mathbb{E}[M\_{t+u} \mid \mathcal{F}\_t]
= M\_t \mathbb{E}[e^{-r^\*(c u - \sum\_{\text{fresh}} Y\_i)}]
= M\_t e^{-r^\* c u} e^{\lambda u (\mathbb{E} e^{rY} - 1)},
$$

where the compound Poisson exponential identity is PROVEN by conditioning on
the number of fresh claims:
$\sum\_{k \ge 0} \mathbb{P}(N = k) (\mathbb{E} e^{rY})^k$ with Poisson weights
$e^{-\lambda u}(\lambda u)^k/k!$ sums to $e^{\lambda u(\mathbb{E} e^{r Y}-1)}$,
the Taylor series of the exponential recognized term by term. The adjustment
equation makes the bracket $\lambda(\mathbb{E} e^{r^\*Y} - 1) - c r^\* = 0$, so
$\mathbb{E}[M\_{t+u} \mid \mathcal{F}\_t] = M\_t$: a martingale. The optional
stopping at the ruin time belongs to the martingale machinery of the course: a
nonnegative process with a conditional-mean-1 increment satisfies
$\mathbb{E}[M\_{T \wedge t}] \le M\_0$ (optional sampling for nonnegative
supermartingales, cited; note $\mathbb{E} M\_{T \wedge t} \le \mathbb{E} M\_0$ in
fact holds with the supermartingale sign and equality requires care that
ruinicity alone does not give). Tag GAP: the stopping-time justification.

On the set $\lbraceT \le t\rbrace$, $X\_T < 0$ (ruin means strictly negative at the
first touch; the surplus has downward jumps, so the first touch passes
below 0), hence $-r^\* X\_T > 0$ and $M\_T = e^{-r^\* X\_T} \ge 1$. Therefore
$\mathbf{1}\_{\lbraceT \le t\rbrace} \le M\_{T \wedge t}$ pointwise (on the ruin
event $M\_T \ge 1$ given the indicator is 1; off the event the indicator
is $0 \le$ the nonnegative $M$). Taking expectations and passing
$t \to \infty$ (monotone convergence on the increasing events, named):

$$
\psi(u) = \mathbb{P}(T < \infty) = \lim\_t \mathbb{P}(T \le t)
\le \lim\_t \mathbb{E} M\_{T \wedge t} \le M\_0 = e^{-r^\* u}.
$$

The Lundberg bound: $\psi(u) \le \exp(-(\gamma - \lambda/c) u)$.
PROVEN up to the cited stopping step. The exponent is a rate function:
$r^\*$ is the root where the tilted claim growth meets the premium growth,
the same Legendre engine as section 4 and case-large-deviations.md.

## 7. Numeric fixture, and the exact answer it shadows

$\lambda = 1$, $\gamma = 1$ (mean claim 1), premium $c = 2$, capital
$u = 3$. Loading check: $c = 2 > \lambda/\gamma = 1$... all conditions
pass. Adjustment root: $r^\* = \gamma - \lambda/c = 1 - 1/2 = 1/2$.
Lundberg bound: $\psi(3) \le e^{-1.5} = 0.2231$. Honest comparison: for
Poisson arrivals and exponential claims the exact ruin probability has
the classical closed form
$\psi(u) = (\lambda/(c \gamma)) \exp(-(\gamma - \lambda/c)u)$ (the
Pollaczek-Khinchin specialization; cited theorem). Numbers:
$(1/(2 \cdot 1)) e^{-1.5} = 0.1116$. Same exponent, prefactor 1/2: the
bound is the honest upper half of the exact pair, as the pre-exponential
constants of section 4 suggested. Capital doubling: $\psi(6)$ via the
exact form $= 0.1116 \cdot e^{-1.5} = 0.0249$ (the bound alone would only
say $\le 0.0498$, and the exponent, not the constant, is what the theory
certifies). SUPPORTED arithmetic; the exact formula is cited.

## 8. Where the frontier is

- Subexponential claim sizes break the adjustment equation:
  $\mathbb{E} e^{rY}$ diverges for every $r > 0$, $r^\* = 0$, and ruin is
  decided by one giant claim rather than an accumulation of medium ones.
  This is the same wall case-large-deviations.md section 7 names, and it
  feeds case-extremes.md directly.
- Gärtner-Ellis: the general theorem converting a fixed-point log-mgf
  like section 3's into a rate for threshold events of memory processes,
  cited (the production advisor's heat sits here).
- Reinsurance and dividend decisions make the surplus a controlled
  process; the ruin minimization problem is a HJB problem, the valuation
  twin of case-merton.md.
