# Case study: the Kelly criterion — log-optimal growth

Quant/finance case #1. Question: what fraction of your wealth should you
risk on a favorable, repeatable bet? The answer falls out of one
representation change (multiplicative → additive) and one derivative. Every
step shown; every number recomputed.

## 1. The model and the fatal wrong question

You may bet any fraction $f \in [0,1)$ of current wealth $W_k$ on each
round. Win (probability $p$): you gain $b f W_k$ (net odds $b$). Lose
(probability $q = 1-p$): you lose $f W_k$. Wealth multiplies:

$$
W_{k+1} = \begin{cases} (1 + bf)\, W_k & \text{with prob. } p, \\
(1 - f)\, W_k & \text{with prob. } q. \end{cases}
$$

The wrong question: "which $f$ maximizes $\mathbb{E}[W_{k+1} \mid W_k]$?"
Since $\mathbb{E}[W_{k+1}] = (1 + (pb - q)f)\, W_k$, expected value demands
$f \to 1$ whenever the bet is favorable ($pb > q$). But $q > 0$ and
$\prod (1-f) = 0$ at $f = 1$: the maximizer of the mean guarantees ruin.
*The mean is the wrong functional because wealth is multiplicative, not
additive.* Fix the representation first (state-versus-representation, rule
7 of the covenant).

## 2. The representation change

Take logs:

$$
\log \frac{W_n}{W_0} = \sum_{k=1}^{n} \log(1 + b f)^{X_k} (1-f)^{1-X_k},
\qquad X_k \in \{0,1\} \text{ the win indicator.}
$$

With $S_n = \sum X_k$ the win count:

$$
\frac{1}{n}\log\frac{W_n}{W_0}
= \frac{S_n}{n}\log(1+bf) + \frac{n-S_n}{n}\log(1-f).
$$

The multiplicative process became an *average of i.i.d. terms*, so the
strong law of large numbers applies ($S_n/n \to p$ a.s.):

$$
\frac{1}{n}\log\frac{W_n}{W_0} \xrightarrow{\text{a.s.}}
g(f) := p\log(1+bf) + q\log(1-f).
$$

**What is proven versus assumed:** the algebraic rewriting is PROVEN
(telescoping of the recursion); the SLLN step is the one machine cited
(committed earlier in the course or a GAP entry). Given SLLN, everything
else on this page is elementary.

## 3. The optimizer, completely

For $f \in [0,1)$:

$$
g'(f) = \frac{pb}{1+bf} - \frac{q}{1-f}, \qquad
g''(f) = -\frac{pb^2}{(1+bf)^2} - \frac{q}{(1-f)^2} < 0,
$$

so $g$ is strictly concave on $[0,1)$ and any interior root of $g'$ is the
unique global maximizer. Solve $g'(f) = 0$:

$$
\begin{aligned}
pb(1-f) = q(1+bf)
&\iff pb - pbf = q + qbf \\
&\iff pb - q = bf(p + q) && \text{(collect } f\text{ terms)}\\
&\iff f^* = \frac{pb - q}{b} = p - \frac{q}{b} && (p+q = 1).
\end{aligned}
$$

Interior feasibility: $f^* > 0 \iff pb > q$ (positive edge), and
$f^* < 1 \iff pb - q < b \iff p < 1$, which holds. If $pb \le q$, concavity
plus $g'(0) = pb - q \le 0$ forces the max at $f = 0$: *never bet without
edge*. $\blacksquare$

## 4. The information-theoretic content (edge = information)

For even odds $b = 1$: $f^* = p - q = 2p - 1$, and

$$
\begin{aligned}
g(f^*) &= p\log(2p) + q\log(2q) && \text{(substitute } 1{+}f^*{=}2p,\ 1{-}f^*{=}2q\text{)}\\
&= \log 2 + p\log p + q\log q && \text{(split each log)}\\
&= \log 2 - H(p), &&
\end{aligned}
$$

where $H(p) = -p\log p - q\log q$ is the binary entropy. **Growth rate
equals $\log 2$ minus entropy**: what you extract per round is exactly what
the outcome's uncertainty *fails* to remove. Kelly's original 1956 paper
titles this rate the channel capacity of the bettor's noisy information
source. Status: the identity is PROVEN; the information-theoretic
interpretation is a theorem-level claim about mutual information, cited,
proof deferred (GAP: Sanov/Kelly correspondence, see
case-large-deviations.md §7).

Numeric fixture (recompute before trusting): $p = 0.6$, $b = 1$,
$f^* = 0.2$:
$g = 0.6\ln 1.2 + 0.4\ln 0.8 = 0.6(0.182322) + 0.4(-0.223144)
= 0.109393 - 0.089257 = 0.020136$ nats/round; and
$\ln 2 - H(0.6) = 0.693147 - 0.673012 = 0.020136$. ✓ Both forms agree, as
proven.

## 5. Why practitioners refuse full Kelly

Per-round log-return $R = \log(1{+}bf)$ or $\log(1{-}f)$ has variance

$$
\operatorname{Var}[R] = pq\,\big[\log(1+bf) - \log(1-f)\big]^2
= pq\,\Big[\log\frac{1+bf}{1-f}\Big]^2,
$$

since $R$ takes two values; $\operatorname{Var}[R] = \mathbb{E}R^2 - (\mathbb{E}R)^2 = pq(\log\tfrac{1+bf}{1-f})^2$
(the standard two-point variable formula — derive: for a variable taking
$u$ w.p. $p$ and $v$ w.p. $q$, $\operatorname{Var} = pq(u-v)^2$, verified by
expanding both sides).

Half-Kelly fixture: $f = f^*/2 = 0.1$ at $p = 0.6$, $b = 1$:
$g(0.1) = 0.6\ln 1.1 + 0.4\ln 0.9 = 0.057186 - 0.042144 = 0.015042$ —
about $75\%$ of the full-Kelly growth for *half* the exposure, and the
log-variance scales down with the bracket $\log\frac{1+bf}{1-f}$
($\log 1.375 \to \log 1.222$: $0.3185 \to 0.2007$, ~$37\%$ less). Status of
the heuristic: SUPPORTED by this computation; the general rule
$g(c f^*) \approx (2c - c^2)\,\max g$ (concavity + Taylor at $f^*$) is an
exercise — prove it using $g''(f^*)$ computed exactly.

## 6. Falsifiable checks

- $f = 0$: $g = 0$. ✓ from the formula (both logs vanish at argument 1).
- $pb \le q$: predicts $f^* = 0$. Pathological without the check: any
  "optimal" formula that outputs $f > 0$ on a losing bet is wrong — the
  algebra in §3 forbids it.
- $f \uparrow 1$ with $q > 0$: $\log(1-f) \to -\infty$ while
  $p\log(1+bf)$ stays bounded, so $g \to -\infty$: overbetting is
  *logarithmically* ruinous, matching the §1 argument.
- Long-run simulation: any honest Monte Carlo at $p{=}0.6, b{=}1, f{=}0.2$
  over $10^5$ rounds must show empirical growth within
  $O(n^{-1/2})$-scale fluctuations of $0.020136$/round (CLT scale for the
  additive log-sum). This is a *test you can run*.

## 7. Where the frontier is

- The enemy is not variance; it is **estimation error in $p$**. The
  objective is an expectation under a measure you do not know; the modern
  fix is distributionally robust optimization: maximize the worst-case
  $\mathbb{E}_{\mathbb{Q} \in \mathcal{P}} \log(\cdot)$ over an ambiguity
  set $\mathcal{P}$. Cited, not covered here.
- Multi-asset Kelly = the log-optimal portfolio problem. Cover &
  Ordentlich's universal portfolio achieves log-wealth within
  $\tfrac{d-1}{2}\log n + O(1)$ of the best constant-rebalanced portfolio
  in hindsight for $d$ assets over horizon $n$ — no probabilistic model at
  all. Cited frontier result; the proof is minimax regret machinery.
- Note the same exponential-accumulation skeleton as case-ewma.md:
  multiplicative memory, thresholds, geometric contraction. The z-transform
  exercise there and the log-transform here are the same move.
