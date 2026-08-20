# Case study: Black–Scholes from Brownian motion — the capstone

Quant/finance case #2 and the debt-payer of the course: it spends every
representation change earned in the other files. Random walk → Brownian
motion → Itô → hedging → PDE → *the PDE is a heat equation* → expectation
form → formula. Long, but no step is skipped and every formula is checked.

## 1. Brownian motion as a scaling limit

Let $X_1, X_2, \dots$ be i.i.d. $\pm 1$ with probability $1/2$, partial sums
$S_n$. Scale space by $\sqrt{n}$ and time by $n$:

$$B_t^{(n)} := \frac{S_{\lfloor nt \rfloor}}{\sqrt{n}}.
$$

Variance computation (complete): each $X_k$ has $\mathbb{E}X_k = 0$,
$\mathbb{E}X_k^2 = 1$, and independence gives

$$
\operatorname{Var} B_t^{(n)} = \frac{1}{n}\operatorname{Var} S_{\lfloor nt \rfloor}
= \frac{\lfloor nt \rfloor}{n} \xrightarrow[n\to\infty]{} t.
$$

By the central limit theorem, $B_t^{(n)} \Rightarrow N(0,t)$; the limit
process $B_t$ is Brownian motion — continuous paths, independent
increments, $B_t \sim N(0,t)$. Status: the variance limit is PROVEN above;
the existence/continuity of the limit process (Donsker's theorem) is cited
machinery (GAP entry).

## 2. Quadratic variation: why $(dB_t)^2 = dt$

Discrete: $\Delta B^{(n)} = \pm 1/\sqrt{n}$, so $(\Delta B^{(n)})^2 = 1/n$
*exactly*, and $[B^{(n)}]_t = \lfloor nt \rfloor \cdot \frac{1}{n} \to t$.
In the limit, increments are Gaussian, so verify the mean-square statement:
with $\Delta = B_{t+h} - B_t \sim N(0,h) = \sqrt{h}\,Z$, $Z \sim N(0,1)$:

$$
\mathbb{E}\big[(\Delta^2 - h)^2\big] = h^2\,\mathbb{E}[(Z^2-1)^2]
= h^2\,(\mathbb{E}Z^4 - 2\mathbb{E}Z^2 + 1) = h^2(3 - 2 + 1) = 2h^2,
$$

where $\mathbb{E}Z^2 = 1$ and $\mathbb{E}Z^4 = 3$; the latter by
integration by parts on the Gaussian density $\varphi$ with
$\varphi' = -z\varphi$:

$$
\mathbb{E}Z^4 = \int z^4 \varphi \, dz = \int z^3 (-\varphi') \, dz
= \big[{-z^3 \varphi}\big]_{-\infty}^{\infty} + 3\int z^2 \varphi \, dz = 0 + 3\cdot 1,
$$

the boundary term vanishing because $\varphi$ decays exponentially.
Mean-square error $2h^2$ against a fluctuation of size $h$: relative error
$\to 0$ as $h \to 0$. Squared increments stop being random at small scale.
PROVEN (modulo the passage to the assembled limit, which needs $L^2$
machinery — tagged).

## 3. Itô's lemma (the scalar form we need)

Let $f \in C^2$. Taylor with remainder:

$$
f(B_{t+h}) - f(B_t) = f'(B_t)\,\Delta + \tfrac{1}{2} f''(B_t)\, \Delta^2 + o(\Delta^2).
$$

Sum over a partition and let the mesh shrink. Two things survive, for
different reasons: $\sum f' \Delta \to \int f' \, dB$ (martingale sums —
tagged machinery), and $\sum f'' \Delta^2 \to \int f'' \, dt$ *because §2
replaces $\Delta^2$ by $dt$ with vanishing mean-square error* — this is the
whole content of Itô's correction. Hence

$$
df(B_t) = f'(B_t)\, dB_t + \tfrac{1}{2} f''(B_t)\, dt.
$$

**Application.** $S_t = S_0 \exp((\mu - \tfrac{\sigma^2}{2})t + \sigma B_t)$.
With $f(t, x) = S_0 e^{(\mu - \sigma^2/2)t + \sigma x}$: $f_t = (\mu - \tfrac{\sigma^2}{2}) f$, $f_x = \sigma f$, $f_{xx} = \sigma^2 f$. Then
(time term plus Itô):

$$
dS = \Big[\big(\mu - \tfrac{\sigma^2}{2}\big) + \tfrac{1}{2}\sigma^2\Big] S\, dt + \sigma S \, dB
= \mu S \, dt + \sigma S \, dB_t. \quad \blacksquare
$$

## 4. The hedging argument, with every term carried

Let $V(t, S) \in C^{1,2}$ be the claim's value function. Itô in $(t, S_t)$
using $dS = \mu S dt + \sigma S dB$ and $(dS)^2 = \sigma^2 S^2 dt$ (from §2):

$$
dV = \Big(V_t + \mu S V_S + \tfrac{1}{2}\sigma^2 S^2 V_{SS}\Big) dt + \sigma S V_S \, dB.
$$

Hold $\Delta$ shares; the portfolio $\Pi = V - \Delta S$ satisfies

$$
d\Pi = \Big(V_t + \mu S V_S + \tfrac{1}{2}\sigma^2 S^2 V_{SS} - \Delta \mu S\Big) dt
+ \sigma S (V_S - \Delta)\, dB.
$$

Choose $\Delta = V_S$: the $dB$ coefficient vanishes **and** the $\mu S V_S$
term cancels the $-\Delta\mu S$ term:

$$
d\Pi = \Big(V_t + \tfrac{1}{2}\sigma^2 S^2 V_{SS}\Big) dt.
$$

$\Pi$ is now instantaneously riskless, so no-arbitrage requires it to earn
the risk-free rate: $d\Pi = r\Pi\,dt = r(V - V_S S)\,dt$. Equating:

$$
\boxed{V_t + \tfrac{1}{2}\sigma^2 S^2 V_{SS} + r S V_S - rV = 0.}
$$

Every cancellation above is visible. Note what *died*: $\mu$ (the drift of
the stock) cancelled. The price of the claim does not care where the stock
is headed — that is not an assumption, it is an algebraic outcome.

## 5. It is the heat equation (representation change, fully executed)

Substitute $x = \ln S$, $\tau = T - t$ (time to expiry). Then

$$
V_S = \frac{V_x}{S}, \qquad V_{SS} = \frac{V_{xx} - V_x}{S^2}, \qquad V_t = -V_\tau,
$$

(the middle one: $\partial_S(V_x/S) = (V_{xx} \cdot S^{-1} \cdot S - V_x)/S^2$);
substituting in the PDE:

$$
V_\tau = \tfrac{1}{2}\sigma^2 V_{xx} + \underbrace{\big(r - \tfrac{1}{2}\sigma^2\big)}_{=:k} V_x - rV.
$$

Remove drift and damping with $V = e^{\alpha x + \beta \tau} u$:
$V_x = e^{\cdot}(u_x + \alpha u)$, $V_{xx} = e^{\cdot}(u_{xx} + 2\alpha u_x + \alpha^2 u)$,
$V_\tau = e^{\cdot}(u_\tau + \beta u)$. Collecting:

$$
u_\tau + \beta u = \tfrac{1}{2}\sigma^2 u_{xx}
+ (\sigma^2 \alpha + k)\, u_x + \big(\tfrac{1}{2}\sigma^2 \alpha^2 + k\alpha - r\big) u.
$$

Kill the $u_x$ term: $\alpha = -k/\sigma^2 = \tfrac12 - r/\sigma^2$. Kill the
$u$ term: $\beta = \tfrac12 \sigma^2 \alpha^2 + k\alpha - r
= -\frac{k^2}{2\sigma^2} - r$ (substitute $\alpha = -k/\sigma^2$:
$\tfrac{k^2}{2\sigma^2} - \frac{k^2}{\sigma^2} - r$). What remains is

$$
u_\tau = \tfrac{1}{2}\sigma^2\, u_{xx},
$$

the heat equation of case-heat-kernel.md, with terminal payoff as initial
data $u(x,0) = e^{-\alpha x}(e^x - K)^+$ read backwards from $V(S,T) =
(S-K)^+$. **The option pricing problem is a diffusion problem; the
$e^{-tL}$ kernel and the Black–Scholes kernel are the same object in
different coordinates.**

## 6. Solving by expectation (the latter half of Feynman–Kac)

One kernel integration is one Gaussian average. Claim:

$$
C = e^{-r\tau}\, \mathbb{E}\big[\big(S e^{(r - \sigma^2/2)\tau + \sigma\sqrt{\tau}\, Z} - K\big)^+\big], \qquad Z \sim N(0,1).
$$

Status: this function is *verified* to satisfy the §4 PDE and the terminal
condition (differentiate under the expectation; the algebra is assigned as
an exercise; the general theorem — expectations of diffusions solve the
backward equation — is cited machinery, GAP).

Now evaluate. With $d_2 := \frac{\ln(S/K) + (r - \sigma^2/2)\tau}{\sigma\sqrt{\tau}}$,
the event $\{S_T > K\}$ is $\{Z > -d_2\}$. Second term:
$e^{-r\tau} K\, \mathbb{P}(Z > -d_2) = K e^{-r\tau} N(d_2)$. First term:
$e^{-r\tau} S e^{(r-\sigma^2/2)\tau}\, \mathbb{E}[e^{\sigma\sqrt\tau Z} \mathbf 1_{Z>-d_2}]$.
Complete the square inside the expectation:

$$
-\tfrac{z^2}{2} + \sigma\sqrt{\tau}\, z = -\tfrac{1}{2}(z - \sigma\sqrt{\tau})^2 + \tfrac{\sigma^2\tau}{2},
$$

so $\mathbb{E}[e^{\sigma\sqrt\tau Z}\mathbf 1_{Z>-d_2}]
= e^{\sigma^2\tau/2}\, N(d_2 + \sigma\sqrt\tau)$. The factors
$e^{-r\tau}e^{(r-\sigma^2/2)\tau}e^{\sigma^2\tau/2} = 1$, and with
$d_1 := d_2 + \sigma\sqrt{\tau}$:

$$
\boxed{C = S\, N(d_1) - K e^{-r\tau} N(d_2), \quad
d_{1,2} = \frac{\ln(S/K) + (r \pm \tfrac12\sigma^2)\tau}{\sigma\sqrt{\tau}}.}
$$

## 7. Falsifiable checks

- **Textbook fixture.** $S = K = 100$, $r = 5\%$, $\sigma = 20\%$, $\tau = 1$:
  $d_1 = (0 + 0.07)/0.2 = 0.35$, $d_2 = 0.15$; $N(0.35) = 0.63683$,
  $N(0.15) = 0.55962$, $e^{-0.05} = 0.951229$:
  $C = 63.683 - 95.123 \times 0.55962 = 63.683 - 53.233 = 10.45$. ✓
  (Recompute; do not trust.)
- **Put-call parity.** Using $N(-d) = 1 - N(d)$:
  $C - P = S(N d_1 + N(-d_1)) - Ke^{-r\tau}(N d_2 + N(-d_2)) = S - Ke^{-r\tau}$.
  ✓ One line of algebra, and it *must* hold or the formula is wrong —
  it is also a direct no-arbitrage identity, a second derivation by a
  different representation.
- **Deterministic limit.** $\sigma\sqrt\tau \to 0$: $d_{1,2} \to \pm\infty$
  according to the sign of $\ln(S/K) + r\tau$, and $C \to
  (S - Ke^{-r\tau})^+$: the formula degenerates to discounted forward
  moneyness, as reason demands.

## 8. Where the frontier is

The smile says the model is wrong in a structured way. The repairs, in
increasing violence: local volatility (Dupire: $\sigma(S,t)$ read off the
option surface), stochastic volatility (Heston: variance itself diffuses),
rough volatility (Gatheral–Jaisson–Rosenbaum: log-volatility drifts like a
*fractional* Brownian motion with $H \approx 0.1$ — not a semimartingale,
so the §4 hedging argument fails and the whole no-arbitrage edifice must be
rebuilt). Transaction costs already destroy perfect replication (Leland;
super-replication, Cvitanić–Karatzas). Each repair is a research program.
