# Case study: the parabolic maximum principle

Rigor case for the heat equation — and the reason "heat does not create hot
spots" is a theorem, not a vibe. Tools: calculus plus one algebra trick.
Then consequences that run the entire qualitative theory in four lines
each, and the honest map of where this line of argument dies and De
Giorgi–Nash begins.

## 1. Statement and the failure of the naive proof

Let $u \in C^{2,1}$ solve $u_t = u_{xx}$ on $\Omega = (0,\ell) \times (0,T]$,
continuous on the closure. The parabolic boundary $\Gamma$ is the bottom
$[0,\ell]\times\{0\}$ plus the two sides $\{0\}\times[0,T]$ and
$\{\ell\}\times[0,T]$.

**Theorem.** $\max_{\overline\Omega} u = \max_\Gamma u$.

Naive attempt: at an interior max $(x_0, t_0)$ with $t_0 > 0$, Fermat gives
$u_x = 0$; concavity in space at a max gives $u_{xx} \le 0$; and
$u_t(x_0, t_0) \ge 0$: if $t_0 < T$ then $u_t = 0$ by Fermat in $t$; if
$t_0 = T$ a maximum on the top cannot be decreasing as $t \uparrow T$.
Combining: $u_t - u_{xx} \ge 0$. But the equation says $u_t - u_{xx} = 0$.
**No contradiction.** The naive proof fails and must be fixed — name the
obstruction before the fix: the equations tolerate *equality* at a flat
maximum, so we must buy strictness.

## 2. The fix: buy strictness for $\varepsilon$

Set $w = u - \varepsilon t$ for $\varepsilon > 0$. Then
$w_t - w_{xx} = u_t - \varepsilon - u_{xx} = -\varepsilon < 0$.

Suppose $w$ had an interior max $(x_0, t_0)$, $t_0 > 0$. Then as above
$w_{xx}(x_0,t_0) \le 0$ and $w_t(x_0,t_0) \ge 0$ (same two-case argument on
$t_0$, applied verbatim). Hence $w_t - w_{xx} \ge 0$ there — contradicting
$w_t - w_{xx} = -\varepsilon < 0$. So $w$ attains its max on $\Gamma \cup
\{t = 0\}$... and $t_0 = 0$ is inside $\Gamma$ by definition, so
$\max_{\overline\Omega} w = \max_\Gamma w$.

Now $\max u \le \max w + \varepsilon T \le \max_\Gamma w + \varepsilon T
\le \max_\Gamma u + \varepsilon T$
(first inequality: $u = w + \varepsilon t \le w + \varepsilon T$
pointwise; second: previous paragraph; third: $w \le u$). Let
$\varepsilon \downarrow 0$: $\max u \le \max_\Gamma u$. The other direction
is $\Gamma \subseteq \overline\Omega$. $\blacksquare$

Note the proof shape: strictify → contradict → unstrictify. This is the
universal opening move of the whole elliptic/parabolic theory.

## 3. Consequences, each in four lines

**Uniqueness of the initial-boundary value problem.** If $u, v$ solve the
equation with the same data on $\Gamma$, then $d = u - v$ solves it with
zero data; $\max d \le 0$ by the theorem, and $\max(-d) \le 0$ by applying
the theorem to $-d$ (which also solves the linear equation). So $d \equiv 0$.
$\blacksquare$

**Comparison principle.** $u \le v$ on $\Gamma$ and both solving ⇒
$u \le v$ everywhere: $d = u - v$ has data $\le 0$ on $\Gamma$, so
$\max d \le 0$. $\blacksquare$

**Positivity preservation.** Data $\ge 0$ on $\Gamma$ ⇒ solution $\ge 0$:
apply the theorem to $-u$, noting $-u \le 0$ on $\Gamma$ then
$\max(-u) \le 0$. $\blacksquare$ — this is *why* the heat kernel
(case-heat-kernel.md §2) is a nonnegative function; positivity is not an
assumption about the kernel, it is forced by the equation.

## 4. The discrete shadow (ties to case-heat-kernel)

The graph case is *elementary* — no calculus needed. Let $M = D^{-1}W$ be
the row-averaging operator of case-heat-kernel.md §1: $(Mv)_i =
\sum_j \frac{W_{ij}}{D_{ii}} v_j$, a convex combination of the $v_j$
(weights nonnegative, summing to $\sum_j W_{ij}/D_{ii} = 1$ by the
definition of $D_{ii}$). Then

$$
(Mv)_i \le \max_j v_j \quad \text{for every } i
\quad\Longrightarrow\quad \max Mv \le \max v.
$$

One line: a convex combination of numbers cannot exceed the largest of
them; $W_{ij} = 0$ terms contribute nothing; done. $\blacksquare$
This is conjecture 6 in `lean/Frontier/Conjectures.lean` — Lean checks what
calculus cannot even see, because the statement needs no smoothness.

## 5. What the principle is for

Discounted: with $u_t = u_{xx} - cu$, the same strictification
($w = u e^{ct}$... check: $w_t = e^{ct}(u_t + cu) = e^{ct} u_{xx} = w_{xx}$, so $w$
solves the plain equation) gives $e^{ct}\max u \le \max_\Gamma (e^{ct}u)$;
on the top edge this forces $\max_{\overline\Omega} u \le \max_\Gamma u^+$ —
the version used for stability estimates in numerics. (Each sub-step: chain
rule on $w = e^{ct}u$; the max comparison; sign tracking. Exercise.)

## 6. Where the frontier is

This whole file assumes $u_{xx}$ *exists*. The frontier begins when it
does not:

- **De Giorgi (1957), Nash (1958), Moser (1961).** Equations
  $\partial_t u = \operatorname{div}(A(x)\nabla u)$ with $A$ merely
  *measurable* and uniformly elliptic still have Hölder-continuous
  solutions: regularity out of measurability. Aronson (1967) then proves
  the heat kernel still has **two-sided Gaussian bounds** — the kernel
  picture of case-heat-kernel.md survives almost-no-coefficients. All
  cited; the proofs (oscillation lemmas, Harnack inequalities) are beyond
  this file but not beyond this course.
- The strictly-comparison trick above fails for fully nonlinear equations;
  the replacement is viscosity solution machinery (Crandall–Ishii–Lions),
  where the maximum principle becomes the *doubling-of-variables*
  argument. Cited.
- Lesson pattern to keep: when smoothness dies, replace pointwise
  inequalities by integrated or tested ones (weak solutions) — yet another
  representation change, rule 7, executed at the frontier.
