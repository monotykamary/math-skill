# Case study: heat diffusion on a graph, derived completely

Second gold standard. The question: given a weighted graph of related
things (files, symbols — anything), how do you rank *what is nearby* in a
principled way? The answer is the heat kernel, and every step from "average
your neighbors" to "meet a Bessel function" is shown here. Complete chains
are tagged PROVEN; where a step needs machinery beyond this file, it is
tagged SUPPORTED with its evidence, or left as an explicit GAP.

## 1. From averaging to linear algebra

Let $G = (V, E)$ be an undirected graph, $|V| = n$, edge $(i,j)$ carrying
conductance $W_{ij} > 0$, $W$ symmetric. Seed node $i$ with value $s_i$.

One diffusion step replaces each value by a conductance-weighted average of
its neighborhood. Writing $D_{ii} = \sum_j W_{ij}$ for total conductance at
node $i$:

$$
v_i' = \frac{\sum_j W_{ij} v_j}{D_{ii}} = (D^{-1} W v)_i .
$$

So one step is $v \mapsto D^{-1}W v$. Iteration gives $(D^{-1}W)^k v$.

**Problem (observe it, do not skip it).** $D^{-1}W$ is generally
*not symmetric*: $(D^{-1}W)^\top = W D^{-1} \ne D^{-1}W$ when degrees differ.
Non-symmetric real matrices can have complex eigenvalues and non-orthogonal
eigenvectors, which wrecks the spectral reading we want (long-lived modes
as coordinates). Fix: conjugate into symmetry. Set

$$
L = I - D^{-1/2} W D^{-1/2}.
$$

$L$ is symmetric: $(D^{-1/2} W D^{-1/2})^\top = (D^{-1/2})^\top W^\top
(D^{-1/2})^\top = D^{-1/2} W D^{-1/2}$. Call $M := D^{-1/2}WD^{-1/2}$ the
symmetric normalized adjacency, so $L = I - M$ and $M = D^{-1/2}(D^{-1}W)
D^{1/2}$: $M$ is *similar* to our averaging operator $D^{-1}W$, hence has
the same eigenvalues, but real ones with an orthonormal eigenbasis
(spectral theorem for symmetric matrices — machinery cited, proof is a
GAP entry unless already committed).

**Claim 1.** The spectrum of $L$ lies in $[0,2]$.
*Proof.* $M$ row-stochastic after similarity: $D^{-1}W\,\mathbf{1} =
\mathbf{1}$ componentwise by definition of $D$, so $1$ is an eigenvalue of
$D^{-1}W$, hence of $M$, hence $0$ is an eigenvalue of $L$. For the band:
$M$'s eigenvalues lie in $[-1,1]$ because $\|M\|_2 \le 1$, shown by
$v^\top M v = \sum_{ij} W_{ij}\, (v_i/\sqrt{D_{ii}})(v_j/\sqrt{D_{jj}})$
with $2|xy| \le x^2+y^2$ giving $|v^\top M v| \le \sum_i v_i^2 = \|v\|^2$.
(Each sub-step: expand the quadratic form, bound each pair, regroup.) So
$\sigma(L) = 1 - \sigma(M) \subseteq [0,2]$. $\blacksquare$

## 2. From steps to flow

Discrete iteration $v_{k+1} = Mv_k$ rewrites as $v_{k+1} - v_k = -(I-M)v_k
= -L v_k$: each step moves $v$ down its $L$-gradient direction by one unit
of step size. Replace the unit step by a limit: $k \to \infty$ while step
size $\Delta t \to 0$ with $t = k\,\Delta t$ fixed. The difference equation
becomes the **heat equation on the graph**,

$$
\frac{d}{dt} v(t) = -L\, v(t), \qquad v(0) = s.
$$

**Claim 2.** $v(t) = e^{-tL} s$, where $e^{A} = \sum_{k\ge0} A^k/k!$.

*Proof.* The series for $e^{-tL}$ converges absolutely for every $t$
(bounded by $e^{\|tL\|}$, comparison test), so term-by-term differentiation
is valid on any finite interval:

$$
\frac{d}{dt}\, e^{-tL} = \sum_{k\ge 1} \frac{(-L)^k t^{k-1}}{(k-1)!}
= -L \sum_{j\ge 0} \frac{(-Lt)^j}{j!} = -L\, e^{-tL}.
$$

So $v(t) = e^{-tL}s$ satisfies the ODE; $v(0) = e^{0} s = s$; and ODE
uniqueness for linear systems (Grönwall / successive approximation — GAP
entry if unproven for you) makes it *the* solution. $\blacksquare$

## 3. Reading the flow (the intuition, earned)

Diagonalize: $L = U \Lambda U^\top$ with $\Lambda = \operatorname{diag}
(\lambda_0 \le \lambda_1 \le \cdots)$, $\lambda_0 = 0$. Since $e^{-tL}$ has
the same eigenvectors with eigenvalues $e^{-t\lambda_j}$, write the seed in
the eigenbasis, $s = \sum_j c_j u_j$:

$$
v(t) = \sum_j e^{-t\lambda_j} c_j u_j .
$$

Every mode decays exponentially at rate $\lambda_j$:

- **Small $t$:** all modes alive; $v(t)$ reflects $s$ blurred a little →
  *heat stays near the seed.*
- **Large $t$:** high-$\lambda$ modes die first; the surviving field is the
  low-lying spectrum → *heat traces the graph's global skeleton.* The
  $u_0$ component ($L u_0 = 0$, i.e. $u_0 \propto D^{1/2}\mathbf{1}$,
  verify: $LD^{1/2}\mathbf{1} = D^{1/2}\mathbf{1} - D^{-1/2}W\mathbf{1} = 0$)
  never dies: total heat $\sum_i (D^{-1/2}v)_i$... conserved along the flow,
  exercises ask you to prove this.

One dial, $t$, interpolates between *local* and *global*. That is the whole
design idea: **diffusion time is the zoom level.**

## 4. Computing $e^{-tL}$ without eigen: Chebyshev

Diagonalizing costs $O(n^3)$. Instead evaluate the *function* $e^{-tL}$ on
the vector by polynomial expansion. Rescale: $\mu := \lambda - 1 \in [-1,1]$
(Claim 1), i.e. work with $M = L - I$ whose spectrum lies in $[-1,1]$. On
$[-1,1]$ expand $e^{-t(1+\mu)}$ in Chebyshev polynomials $T_k$:

$$
e^{-t(1+\mu)} = I_0(t)\,T_0(\mu) + 2\sum_{k\ge1} (-1)^k I_k(t)\, T_k(\mu),
$$

where $I_k$ is the modified Bessel function. (Proof of the expansion:
substitute $\mu = \cos\theta$, use the Jacobi–Anger identity — GAP entry;
the identity itself is the standard generating function of $I_k$.)

Then $e^{-tL} = e^{-t}\, e^{-tM}$ inherits the expansion. The win: no
$k$-th power of $M$ is ever formed. The *vectors* $T_k(M)s$ obey the
three-term recurrence

$$
T_0 s = s, \quad T_1 s = Ms, \quad T_k s = 2M(T_{k-1}s) - T_{k-2}s,
$$

provable from $T_k(\mu) = 2\mu T_{k-1}(\mu) - T_{k-2}(\mu)$ (which follows
from $\cos k\theta = 2\cos\theta\cos(k-1)\theta - \cos(k-2)\theta$, an
addition-formula identity). So $K$ matrix-vector products — $O(K|E|)$ work
— approximate the full heat field. A new $t$ needs only new coefficients,
not a new walk.

Truncation order used in production: $K \approx \lceil 2.2t \rceil + 16$,
capped at 90. Measured error against an independent scaling-and-squaring
Taylor method: $\sim 6\times 10^{-9}$ — **SUPPORTED** evidence for the
truncation choice, not a proof of it.

## 5. A conjecture refuted by computation

Wavelet frames (SGWT tradition) truncate their expansions *with* a Jackson
damping window, because their compactly supported bumps ring at the window
edge (Gibbs phenomenon). Natural conjecture:

> HYPOTHESIZED: our Chebyshev truncation should also get a Jackson window.

Test the premise, not the authority of tradition. The premise for Jackson
damping is ringing, which comes from slow coefficient decay. Here the
expanded function $e^{-t(1+\mu)}$ is $C^\infty$ on $[-1,1]$, and
Chebyshev coefficients of $C^\infty$ functions decay faster than any
polynomial rate (SUPPORTED here by the measured $6\times 10^{-9}$ at
$K = 90$; the theorem itself — repeated integration by parts after
$\mu = \cos\theta$ — is a documented GAP). Adding a window would convolve
in new error to cure none.

Verdict: **REFUTED.** The production code carries no damping window, and
the measurement is what decided it. This is the workflow: conjecture,
identify the load-bearing premise, compute, keep or kill.

## 6. What to take away

- averaging → matrix → symmetrize → spectrum → flow → fast evaluation:
  five representation changes, each one earned by a stated obstruction.
- One free parameter ($t$) with a physical reading (zoom).
- One measured number ($6\times10^{-9}$) standing in for a theorem until
  the theorem is committed.

Conjectures tied to this case live in `lean/Frontier/Conjectures.lean`
(the parts provable with undergraduate tools; deeper parts stay GAP-tagged).
