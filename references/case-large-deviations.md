# Case study: large deviations — thresholds decay exponentially

The combustion case (case-ewma.md) ended with a threshold and a crossing
time. Here is the general law underneath every such threshold story: sums
of random terms deviate from their mean with probability decaying
*exponentially*, and the decay rate is a Legendre transform. Upper bound
proved completely; the matching lower bound is stated and honestly tagged.

## 1. Markov's inequality, proved from the indicator axiom

For $Y \ge 0$ and $a > 0$: pointwise,
$Y \ge a\,\mathbf 1_{\{Y \ge a\}}$ (if $Y < a$ the right side is $0$;
otherwise it is $a \le Y$). Take expectations — monotonicity of expectation:

$$
\mathbb{E}Y \ge a\, \mathbb{E}\mathbf 1_{\{Y \ge a\}} = a\, \mathbb{P}(Y \ge a)
\quad\Longrightarrow\quad
\mathbb{P}(Y \ge a) \le \frac{\mathbb{E}Y}{a}. \quad \blacksquare
$$

## 2. The exponential tilt

Let $X_1, \dots, X_n$ be i.i.d. with mean $\mu$ and moment generating
function $M(t) = \mathbb{E}e^{tX}$, and $S_n = \sum X_i$. For $a > \mu$ and
any $t \ge 0$, the indicator trick above upgrades:

$$
\mathbf 1_{\{S_n \ge na\}} \le e^{t(S_n - na)},
$$

because if $S_n < na$ the left side is $0 \le$ right side, and if
$S_n \ge na$ the exponent is $\ge 0$ so the right side is $\ge 1$. Both
cases checked — that is the *whole* inequality. Expectations:

$$
\mathbb{P}(S_n \ge na) \le e^{-nta}\, \mathbb{E}\, e^{tS_n}
= e^{-nta}\, M(t)^n
= \exp\{ -n\,(ta - \Lambda(t))\},
$$

where $\Lambda(t) := \log M(t)$ and independence was used exactly once:
$\mathbb{E}\prod e^{tX_i} = \prod \mathbb{E}e^{tX_i}$ (nonnegative,
so Tonelli applies).

The bound holds for every $t \ge 0$, so take the best:

$$
\boxed{\mathbb{P}(S_n \ge na) \le \exp\{-n\, I(a)\}, \qquad
I(a) := \sup_{t \ge 0} [ta - \Lambda(t)].}
$$

PROVEN. $I$ is the Legendre transform of $\Lambda$.

## 3. $\Lambda$ is convex because it is a logarithm of a Laplace transform

Compute: $\Lambda'(t) = \mathbb{E}[X e^{tX}]/M(t)$ and

$$
\Lambda''(t) = \frac{\mathbb{E}[X^2 e^{tX}]}{M(t)} - \left(\frac{\mathbb{E}[X e^{tX}]}{M(t)}\right)^2
= \operatorname{Var}_{\mathbb{Q}_t}[X] \ge 0,
$$

where $\mathbb{Q}_t$ is the *tilted* measure $d\mathbb{Q}_t/d\mathbb{P}
= e^{tX}/M(t)$ — a genuine probability (nonnegative, integrates to $M(t)/M(t)=1$),
and its variance is the difference shown (expand the definition). So
$\Lambda$ is convex, hence $t \mapsto ta - \Lambda(t)$ is concave, and the
supremum is attained where $t = t_a$ solves $\Lambda'(t_a) = a$ when a
solution exists. Also $\Lambda(t) \ge t\mu$ by Jensen ($e^{tX}$ convex in
$X$: $\mathbb{E}e^{tX} \ge e^{t\mu}$), so $I(a) \ge 0$, with $I(\mu) = 0$
(take $t = 0$: $I(\mu) \le 0$ from $t=0$; $I \ge 0$ always). All proven.

## 4. Two computed rate functions

**Gaussian, $X \sim N(\mu, \sigma^2)$.** $M(t) = \exp(\mu t + \sigma^2 t^2/2)$,
so $\Lambda(t) = \mu t + \sigma^2 t^2/2$, and the concave quadratic
$ta - \Lambda(t)$ peaks at $t_a = (a-\mu)/\sigma^2$:

$$
I(a) = \frac{(a-\mu)^2}{2\sigma^2}.
$$

Honesty check: does the bound match the truth? Mills's ratio upper bound:
for $x > 0$,

$$
\bar\Phi(x) = \int_x^\infty \varphi(t)\,dt \le \int_x^\infty \frac{t}{x}\, \varphi(t)\, dt = \frac{\varphi(x)}{x},
$$

using $t/x \ge 1$ on the range and $\int_x^\infty t \varphi(t) dt = \varphi(x)$
(since $(-\varphi)' = t\varphi$). So $\log \bar\Phi(x) = -x^2/2 + O(\log x)$:
the Chernoff exponent is *exactly right at log scale* for Gaussians.
PROVEN as an upper bound on both sides; the matching lower bound
($\bar\Phi(x) \ge \varphi(x)/(x + 1/x)$) is cited, proof by a similar
one-liner — exercise.

**Fair coin, $X = \pm 1$.** $M(t) = \cosh t$. The condition
$\Lambda'(t_a) = a$ reads $\tanh t_a = a$, i.e.
$t_a = \operatorname{artanh} a = \tfrac12 \ln\frac{1+a}{1-a}$. Now
$\cosh(\operatorname{artanh} a) = 1/\sqrt{1 - a^2}$ (from
$1 - \tanh^2 = \operatorname{sech}^2$), so

$$
\begin{aligned}
I(a) &= a\, t_a - \log \cosh t_a \\
&= \frac{a}{2}\ln\frac{1+a}{1-a} + \frac{1}{2}\ln(1 - a^2) && \text{(log cosh} = -\tfrac12\ln(1-a^2)\text{)}\\
&= \tfrac{1}{2}(1{+}a)\ln(1{+}a) + \tfrac{1}{2}(1{-}a)\ln(1{-}a),
\end{aligned}
$$

the binary relative entropy $D(\tfrac{1+a}{2} \,\|\, \tfrac12)$.

## 5. The contrast that makes the point

$X = \pm 1$ fair, $n = 100$, $a = 0.4$:

- Chernoff: $I(0.4) = 0.5\,[1.4 \ln 1.4 + 0.6 \ln 0.6]
= 0.5\,[0.471061 - 0.306495] = 0.082283$,
so $\mathbb{P}(S_{100} \ge 40) \le e^{-8.2283} \approx 2.7 \times 10^{-4}$.
- Chebyshev: $\operatorname{Var} S_{100} = 100$, so
$\mathbb{P}(|S_{100}| \ge 40) \le 100/1600 = 1/16 = 0.0625$.

Same event, same ingredients (mean, variance) versus one more ingredient
(the mgf): $10^{-4}$ versus $10^{-1}$. This is the quantitative difference
between "unlikely" and "essentially never," fully computed — simulate if
you doubt it.

## 6. Back to the accumulator

case-ewma.md asked for the crossing turn of a *deterministic* filter. The
random version — heat fed by random scores — is a time series with memory,
and i.i.d. Chernoff no longer applies verbatim. The upgrade is the
Gärtner–Ellis theorem: replace $n\Lambda(t)$ by the *asymptotic* log-mgf
$\lim_n \tfrac1n \log \mathbb{E} e^{t S_n}$, assumed to exist; the rate
function is again its Legendre transform. Cited; this is the correct tool
for threshold-crossing risk in systems with memory, including the
advisor's heat.

## 7. Where the frontier is

- **Sanov's theorem**: the empirical measure itself is exponentially
  unlikely at rate $D(\cdot \| \mathbb{P})$ — and $D$ is the same
  relative entropy that appeared as the Kelly growth rate. The Kelly
  identity $g(f^*) = \log 2 - H$ of case-kelly.md is a shadow of this
  correspondence. Cited.
- The Gaussian assumption is where finance breaks: returns have
  *subexponential* tails, $M(t) = \infty$ for all $t > 0$, §2 gives
  the empty bound $e^{-\infty \cdot 0}$, and the theory restarts with
  extreme value theory (GPD tail fitting; von Mises conditions). Cited
  frontier; knowing where your machine's hypotheses fail *is* the craft.
