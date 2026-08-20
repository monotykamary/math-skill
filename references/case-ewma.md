# Case study: exponential accumulation, proved completely

This file is the gold standard for what "no skipped steps" means in this
course. It works one real design to bedrock: the heat accumulator behind a
production hint system. Everything below is PROVEN unless explicitly tagged
otherwise.

## 1. The model

A system watches a stream of evidence. Each turn k it receives a score
$s_k \ge 0$ (how strongly the current input points to some capability). It
keeps a scalar state $W_k$, called heat, updated by

$$
W_0 = 0, \qquad W_{k+1} = (1-\rho)\, s_{k+1} + \rho\, W_k \qquad (k \ge 0),
$$

where $\rho \in (0,1)$ is a fixed retention factor. (In the production system
$\rho = 1 - 1/\tau$ for a memory scale $\tau$; the default $\tau = 2$ gives
$\rho = 1/2$.) The system fires when $W_k$ crosses a threshold $\theta$.

The intuition to *earn*: each turn forgets a $(1-\rho)$-fraction of the
accumulated state and replaces that fraction with new evidence. Heat is a
decaying memory, not a sum.

## 2. Constant input: conjecture

Hold the input constant: $s_k = s$ for all $k$. Compute the first values
from the definition, one step each:

$$
\begin{aligned}
W_1 &= (1-\rho)s + \rho\cdot 0 = s(1-\rho), \\
W_2 &= (1-\rho)s + \rho\cdot s(1-\rho) = s\,(1-\rho)(1+\rho), \\
W_3 &= (1-\rho)s + \rho\, s(1-\rho)(1+\rho) = s\,(1-\rho)(1+\rho+\rho^2).
\end{aligned}
$$

The pattern $\sum_{i<k}\rho^i$ suggests $W_k = s(1-\rho^k)$, using the
geometric identity

$$
(1-\rho)\sum_{i=0}^{k-1}\rho^i = 1-\rho^k,
$$

which itself is proved by induction: base $k=1$ gives $(1-\rho)\cdot 1 =
1-\rho$; step: $(1-\rho)\sum_{i=0}^{k}\rho^i = (1-\rho^k) + (1-\rho)\rho^k
= 1 - \rho^{k+1}$. $\blacksquare$

**Claim (HYPOTHESIZED).** $W_k = s\,(1-\rho^k)$ for all $k \ge 0$.

**Test (SUPPORTED).** $\rho = 1/2$, $s = 1$: $W_4 \stackrel{?}{=} 15/16$.
From the recursion: $W_1 = 1/2$, $W_2 = 3/4$, $W_3 = 7/8$, $W_4 = 15/16$
by direct halving arithmetic; from the formula: $1 - (1/2)^4 = 15/16$. ✓

**Proof (PROVEN).** Induction on $k$.
Base $k=0$: RHS $= s(1-\rho^0) = s\cdot 0 = 0 = W_0$. ✓
Step: assume $W_k = s(1-\rho^k)$. Then

$$
\begin{aligned}
W_{k+1}
&= (1-\rho)s + \rho\, W_k && \text{(definition of } W \text{)}\\
&= (1-\rho)s + \rho\, s\,(1-\rho^k) && \text{(induction hypothesis)}\\
&= s\,\big[(1-\rho) + \rho - \rho^{k+1}\big] && \text{(distribute } \rho \text{)}\\
&= s\,(1-\rho^{k+1}) && (\,1 - \rho + \rho = 1\,). \quad \blacksquare
\end{aligned}
$$

## 3. Fixed point and stability

**Claim.** $W_k \to s$ as $k \to \infty$, and no other limit is possible.

From §2, $W_k - s = -s\rho^k$, and $\rho^k \to 0$ because $|\rho| < 1$
(archimedean property: for $\varepsilon > 0$, pick $k >
\ln\varepsilon / \ln \rho$; note $\ln \rho < 0$ so the division flips the
inequality). Uniqueness: if $W^*$ were a fixed point, $W^* = (1-\rho)s +
\rho W^*$, so $W^*(1-\rho) = (1-\rho)s$, and dividing by $1-\rho \ne 0$
forces $W^* = s$. $\blacksquare$

Note the *rate*: the error $W_k - s = -s\rho^k$ shrinks by the factor
$\rho$ per turn. Distance to the fixed point contracts geometrically. This
is why a one-turn interruption only delays things: related evidence that
arrives later resumes from a halved (not zeroed) deficit.

## 4. Crossing time

With constant input $s$ and threshold $\theta < s$, the fire turn is the
smallest $k$ with $W_k \ge \theta$. Using § 2:

$$
\begin{aligned}
s(1-\rho^k) \ge \theta
&\iff 1 - \rho^k \ge \theta/s && \text{(divide by } s > 0\text{; sign unchanged)}\\
&\iff \rho^k \le 1 - \theta/s && \text{(negate: inequality flips, twice)}\\
&\iff k \ln \rho \le \ln(1 - \theta/s) && \text{(}\ln\text{ is increasing)}\\
&\iff k \ge \frac{\ln(1-\theta/s)}{\ln \rho} && \text{(divide by } \ln\rho < 0\text{: flip).}
\end{aligned}
$$

Hence

$$
k_{\mathrm{fire}} = \Big\lceil \frac{\ln(1-\theta/s)}{\ln\rho} \Big\rceil .
$$

**Fixture (SUPPORTED).** $\rho = 1/2$, $s = 3/2$, $\theta = 9/10$:
$1 - \theta/s = 1 - (9/10)(2/3) = 1 - 3/5 = 2/5$; $\ln(2/5)/\ln(1/2)
\approx (-0.916)/(-0.693) \approx 1.32$; ceiling $= 2$. So we predict: turn
1 stays below threshold, turn 2 fires. Check directly: $W_1 = (3/2)(1/2)
= 3/4 = 0.75 < 0.9$ ✓; $W_2 = (3/2)(3/4) = 9/8 = 1.125 \ge 0.9$ ✓.
(The production system documents exactly this fixture.)

## 5. Feedback: why one miss can lock a lane out

Suppose weak evidence is capped: no matter how much raw overlap, the lane
contributes at most $s = q = 1$ per turn (scatter cap). Then the supremum
of reachable heat is the fixed point $s = 1$, never reached from below.

Now add anti-spam feedback: each ignored hint raises the threshold to
$\theta_i = \theta\,(1 + n/\tau^2)$ after a streak of $n$ misses.

**Claim.** At defaults $\theta = 0.9$, $\tau = 2$, one miss ($n=1$) permanently
bars the capped lane.

**Proof.** After one miss, $\theta_i = 0.9\,(1 + 1/4) = 1.125$. The capped
lane satisfies $W_k < 1$ for every finite $k$ (§ 3: $W_k = 1 - \rho^k < 1$),
while firing needs $W_k \ge \theta_i = 1.125$. Since $1 - \rho^k < 1 < 1.125$
for all $k$, no turn ever fires. $\blacksquare$

This is the whole safety property of the production system, and it is a
**two-line consequence of the closed form.** This is why closed forms are
worth proving: properties that simulation only *suggests* become theorems.

## 6. The representation change

The recursion $W_{k+1} = (1-\rho)s + \rho W_k$ and the closed form
$W_k = s(1-\rho^k)$ are the same object; but §§ 3–5 were essentially
impossible to see from the recursion and essentially trivial from the closed
form. When a question about a process resists you, **change what the object
is**: unroll it, telescope it, or transform it (z-transform is the
systematic version; the generating function $G(z) = \sum_k W_k z^k$ turns the
recursion into algebra: try it as an exercise).

Conjectures tied to this case live in `lean/Frontier/Conjectures.lean`.
