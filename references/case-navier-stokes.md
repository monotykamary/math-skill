# Case study: Navier–Stokes breakdown with smooth forcing

Frontier reading case. OpenAI announced a proposed solution on
2026-09-08 and released a paper with a Lean formalization. The result
concerns finite-time breakdown for the **forced**, three-dimensional,
incompressible Navier–Stokes equations at positive viscosity.

Read after [Burgers](case-burgers.md) and [Kolmogorov](case-kolmogorov.md).
Prerequisites: integration by parts, divergence-free vector fields, and
$L^2$ and $L^\infty$ norms. The local target is to prove the energy identity
and test whether an energy bound can control the largest velocity.
The full breakdown construction remains an external proof to audit.

## 1. Sources and evidence boundary

Source snapshot checked: **2026-09-09**.

- [OpenAI announcement][announcement], “An OpenAI model proposes a
  solution to the Navier–Stokes problem,” 2026-09-08. This identifies the
  release; use the mathematical artifacts below for the theorem.
- [OpenAI, *Finite Time Blowup for Navier–Stokes*][paper], Theorem 1.1
  and Corollary 10.6. Sections 2 and 3 describe the construction.
- [Lean formalization][formalization], pinned to commit
  `8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538`. Its README states the
  whole-space and periodic results and gives the build procedure. The
  complete source is also [vendored locally](../vendor/openai-navier-stokes/README.md),
  with its license and [author credits](../THIRD_PARTY_NOTICES.md) preserved.
- [Fefferman's official Clay problem description][clay], pages 1–2.
  This supplies the admissibility conditions and alternatives (A)–(D).

The retrieved paper has SHA-256
`0e779481c4da40bd28d1e642e1d8ca57447d129610df28dfa5a11e9af8ae228f`.
A later revision needs a fresh statement comparison.

**External claim:** the paper and repository assert proofs of breakdown
alternatives (C) and (D). **Local status: GAP.** We inspected the statement
and verification instructions; we have not reproduced the full derivation,
run the upstream Lean build, or run its independent checker. Publication
with a formalization does not make this a locally PROVEN or COMMITTED
journal entry. No claim of Clay acceptance or a prize award is made here.

The energy identity in section 4 and the norm counterexample in section 5
are PROVEN by the displayed calculations under their stated hypotheses.
They do not certify the external theorem.

## 2. State exactly what is claimed

Let $u(x,t)\in\mathbb R^3$ be velocity, $p(x,t)$ pressure per unit density,
$f(x,t)\in\mathbb R^3$ external force per unit mass, and $\nu>0$ viscosity.
On $\mathbb R^3$, the equations are

$$
\partial_t u+(u\cdot\nabla)u-\nu\Delta u+\nabla p=f,
\qquad \nabla\cdot u=0.
$$

**Cited statement, Theorem 1.1.** For every $\nu>0$, there exist
$f\in C_c^\infty(\mathbb R^3\times(0,\infty);\mathbb R^3)$, a compact set
$K\subset\mathbb R^3$, and smooth fields $u,p$ on
$\mathbb R^3\times[0,1)$ satisfying these equations and

$$
u(\cdot,0)=0,\qquad
\operatorname{supp}u(\cdot,t)\cup\operatorname{supp}p(\cdot,t)\subset K,
$$

$$
\sup_{0\le t<1}\|u(t)\|_{L^2(\mathbb R^3)}<\infty,
\qquad
\limsup_{t\uparrow1}\|u(t)\|_{L^\infty(\mathbb R^3)}=\infty.
$$

Here $C_c^\infty$ means smooth with compact support. In particular, the
force is smooth through $t=1$ and vanishes near the initial time.
The singularity belongs to the velocity; singular forcing is excluded.

The paper further asserts that the same force and initial datum admit no
smooth solution on $\mathbb R^3\times[0,\infty)$ with uniformly bounded
kinetic energy. This is alternative **(C)**. Corollary 10.6 supplies the
periodic counterpart on $\mathbb T^3=\mathbb R^3/\mathbb Z^3$, alternative
**(D)**. The comparison with any hypothetical global solution, and the
localization and rescaling for the periodic construction, are part of the
external proof. Local status: GAP.

Scope checklist:

- Keep the quantifiers: for **every** positive viscosity there **exist**
  suitable data and a force. This gives no claim about every fluid flow.
- Retain the force. Clay's breakdown alternatives (C) and (D) permit
  smooth forcing with specified decay. Compact support meets those decay
  conditions because each derivative is bounded on a compact set and
  vanishes outside it.
- Clay explicitly asks for a proof of one of (A)–(D). Forced breakdown
  can therefore address the stated prize problem. It does not establish
  blowup with $f=0$ or disprove the unforced existence assertions (A)/(B).
- Keep Euler separate. The upstream repository also contains an unforced
  Euler result, where $\nu=0$. Its theorem and proof require a separate
  audit.

## 3. Conjecture before the mechanism

Ask one question at a time. Stop for his calculation.

1. If $\int_{\mathbb R^3}|u|^2\,dx$ stays bounded, must
   $\sup_x|u(x)|$ stay bounded? State a bound or propose a counterexample.
2. Choose a divergence-free profile $U$. For $v_\lambda(x)=A U(\lambda x)$,
   which power of $\lambda$ should $A$ use to keep the energy fixed?

Enter his answer as HYPOTHESIZED. Reveal section 4 when he has predicted
which terms can change the total energy. Use section 5 to test his norm
claim before discussing the source's construction.

## 4. The energy identity, with every cancellation

Work on a smooth time interval. Assume $u,p$ have a common compact spatial
support on each compact time subinterval, so differentiation under the
integral and the following boundary cancellations are valid. Define

$$
E(t)=\frac12\int_{\mathbb R^3}|u(x,t)|^2\,dx,
\qquad
\|\nabla u\|_2^2=\sum_{i,j=1}^3\int_{\mathbb R^3}(\partial_j u_i)^2\,dx.
$$

The chain rule and the momentum equation give

$$
E'(t)=\int u\cdot\partial_tu
=-\int u\cdot(u\cdot\nabla)u
+\nu\int u\cdot\Delta u-\int u\cdot\nabla p+\int u\cdot f.
$$

All integrals here are over $\mathbb R^3$. For transport, the product rule
and incompressibility give

$$
\begin{aligned}
\int u\cdot(u\cdot\nabla)u
&=\sum_{i,j}\int u_i u_j\partial_j u_i\\
&=\frac12\sum_j\int u_j\partial_j(|u|^2)\\
&=\frac12\int\nabla\cdot(|u|^2u)
 -\frac12\int |u|^2\nabla\cdot u=0.
\end{aligned}
$$

The divergence integral vanishes by compact support. Pressure cancels
by the same boundary condition and $\nabla\cdot u=0$:

$$
\int u\cdot\nabla p
=\int\nabla\cdot(pu)-\int p\nabla\cdot u=0.
$$

For viscosity, integration by parts in each coordinate yields

$$
\int u\cdot\Delta u
=\sum_{i,j}\int u_i\partial_j^2u_i
=-\sum_{i,j}\int(\partial_j u_i)^2=-\|\nabla u\|_2^2.
$$

Substitution and integration in time now give

$$
\boxed{E'(t)+\nu\|\nabla u(t)\|_2^2=\int u(x,t)\cdot f(x,t)\,dx,}
$$

$$
E(t)+\nu\int_0^t\|\nabla u(s)\|_2^2\,ds
=E(0)+\int_0^t\int u(x,s)\cdot f(x,s)\,dx\,ds.
$$

PROVEN under the stated smoothness and support assumptions. This is an
identity on the smooth interval; extension through a singular time has
not been assumed.

Special-case check: with $u(\cdot,0)=0$ and $f=0$, the right side is zero.
Both terms on the left are nonnegative. Hence $E(t)=0$, so smoothness
implies $u(x,t)=0$ everywhere on this interval. A construction that starts
from rest must receive energy from its force before it can break down.

## 5. Bounded energy allows concentration

Fix a nonzero smooth compactly supported divergence-free vector field
$U$ on $\mathbb R^3$. Such fields can be constructed as
$U=(\partial_2\psi,-\partial_1\psi,0)$ for a smooth compactly supported
$\psi$ with a nonzero derivative in the first two coordinates. Indeed,

$$
\nabla\cdot U=\partial_1\partial_2\psi-\partial_2\partial_1\psi=0
$$

by equality of mixed derivatives. Normalize $U$ by its nonzero $L^2$
norm, so $\|U\|_2=1$. For $\lambda\ge1$, define

$$
v_\lambda(x)=\lambda^{3/2}U(\lambda x).
$$

The chain rule preserves incompressibility:
$\nabla\cdot v_\lambda=\lambda^{5/2}(\nabla\cdot U)(\lambda x)=0$.
With $y=\lambda x$, the volume element is $dx=\lambda^{-3}dy$. Thus

$$
\|v_\lambda\|_2^2
=\int\lambda^3|U(\lambda x)|^2\,dx
=\lambda^3\lambda^{-3}\int|U(y)|^2\,dy=1.
$$

Since $x\mapsto\lambda x$ maps $\mathbb R^3$ onto itself,

$$
\|v_\lambda\|_\infty=\lambda^{3/2}\|U\|_\infty\longrightarrow\infty.
$$

Each derivative adds a factor $\lambda$, so the same substitution gives

$$
\|\nabla v_\lambda\|_2^2
=\lambda^5\lambda^{-3}\|\nabla U\|_2^2
=\lambda^2\|\nabla U\|_2^2.
$$

The support shrinks by $\lambda^{-1}$. All these supports lie in a fixed
ball containing the support of $U$.

Numeric fixture, with the last two columns expressed as ratios to $U$:

| $\lambda$ | $\frac12\|v_\lambda\|_2^2$ | $\|v_\lambda\|_\infty/\|U\|_\infty$ | $\|\nabla v_\lambda\|_2^2/\|\nabla U\|_2^2$ |
|---|---|---|---|
| 1 | $1/2$ | 1 | 1 |
| 4 | $1/2$ | 8 | 16 |
| 16 | $1/2$ | 64 | 256 |

Check: $4^{3/2}=(\sqrt4)^3=8$ and
$16^{3/2}=(\sqrt{16})^3=64$; the gradient ratios are $4^2$ and $16^2$.
PROVEN: an $L^2$ bound alone cannot imply an $L^\infty$ bound, even for
smooth compactly supported divergence-free fields in a fixed ball.
The displayed arithmetic checks the formulas at finite scales.

These are spatial test fields. They have no demonstrated Navier–Stokes
time evolution, initial datum, or admissible force. Calling this scaling
family a solution of the breakdown problem leaves a GAP.

## 6. Where the external proof does the hard work

For any chosen divergence-free $u$ and pressure $p$, defining

$$
f:=\partial_tu+(u\cdot\nabla)u-\nu\Delta u+\nabla p
$$

makes the momentum equation hold by substitution. If $u$ becomes
singular, this formula alone gives no smoothness guarantee for $f$.
Every derivative of the residual must extend through the singular time,
and the force must meet the support and decay requirements.

The paper's sections 2–3 describe a contracting vortex with different
radial and axial scales. Its core satisfies the leading momentum balance.
Joining that core to an exterior creates a singular residual in an
annulus. Oscillatory corrections supply nonlinear momentum fluxes that
cancel this residual. Further corrections control the errors to every
order. The final localization produces the compactly supported force.

This paragraph is a cited roadmap. The profile construction and its
estimates remain GAP here. To close it, work through the cited paper's
sections 4–9, then section 10's forcing extension, whole-space breakdown,
and periodic corollary. Section 5's norm calculation supplies intuition;
it provides none of those estimates.

## 7. Formalization audit and journal gate

Audit the [vendored source](../vendor/openai-navier-stokes/README.md) as a
separate project. This skill's `lean/` sandbox pins Lean `v4.33.0`. The
source snapshot uses `v4.34.0-rc2`; leave the sandbox toolchain unchanged.
From the math-skill repository root:

```bash
cd vendor/openai-navier-stokes/upstream
shasum -a 256 -c ../SHA256SUMS
lake exe cache get
lake build NavierStokes
lake env lean NavierStokes/ComparatorSolution.lean
```

Only copy-integrity checks have been run locally. The build and proof
checking commands are reproduction instructions. Inspect the source and
dependencies before executing them. Cache retrieval and compilation may
require substantial resources. `lake build` without a target also builds
the companion Euler development and the reference challenge modules.

The pinned [Comparator instructions][comparator] require `landrun`,
`lean4export`, and `nanoda_bin` on `PATH`. After that setup, the upstream
Navier–Stokes check is:

```bash
lake exe comparator ComparatorChallenges/NavierStokes.json
```

The [challenge configuration][challenge] checks these exact targets:

- `NavierStokes.Comparator.navier_stokes_breakdown_R3`
- `NavierStokes.Comparator.navier_stokes_breakdown_periodic`

It enables `nanoda` and permits `propext`, `Quot.sound`, and
`Classical.choice`. Record the actual axiom dependencies; a missing proof
or an extra assumption must remain visible.

The challenge module contains intentional `sorry` placeholders for the
reference statements. The solution module, `NavierStokes.ComparatorSolution`,
exposes proof adapters under those names and includes `#print axioms`
commands. Audit the solution's dependencies rather than treating a raw
repository-wide placeholder count as the proof verdict.

Audit checklist:

- Compare the theorem types and all definitions with Clay (C)/(D).
  Check forcing regularity through the blowup time, spatial decay,
  quantifiers, solution smoothness, and the whole-space energy condition.
- Inspect the dependency closure for `sorry`/`sorryAx` and added axioms.
  A successful build alone does not check that the encoded statement is
  the intended mathematical statement.
- Record the pinned commit, toolchain, commands, and checker outputs.
  Separate a kernel/checker pass from the statement-correspondence audit.
- Keep the breakdown result as an external reference until those checks
  are complete. Commit local learning claims only after he supplies their
  proof and his own explanation. Adding this case proves nothing about
  his current mastery.

[announcement]: https://openai.com/index/navier-stokes-solution/
[paper]: https://cdn.openai.com/pdf/32d9f210-8b73-45e0-91bc-82a30aef8a9a/navier-stokes.pdf
[formalization]: https://github.com/openai/NavierStokesAndEuler/tree/8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538
[clay]: https://www.claymath.org/wp-content/uploads/2022/06/navierstokes.pdf
[comparator]: https://github.com/openai/NavierStokesAndEuler/blob/8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538/ComparatorChallenges/README.md
[challenge]: https://github.com/openai/NavierStokesAndEuler/blob/8937a8f4cbc7abaab5e9e97d1cc7f5d2319d9538/ComparatorChallenges/NavierStokes.json
