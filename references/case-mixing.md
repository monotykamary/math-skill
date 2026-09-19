# Case study: how long until a Markov chain forgets its start

The threshold question of case-ewma.md, asked in probabilistic form. The
object is a lazy random walk on a cycle of nine sites. The engine is the
same one that ran case-heat-kernel.md: symmetrize, take the spectrum, read
the second eigenvalue as the forgetting rate. The mixing time bound follows
from one Cauchy-Schwarz inequality and one tangent inequality. Every step
is named; every threshold number is recomputed.

## 1. The chain and the distance

Cycle $C\_9$ with sites $0, \dots, 8$ indexed mod $9$. One step: stay with
probability $1/2$, move to each neighbor with probability $1/4$. The
transition matrix:

$$
P(x,y) = 1/2 \text{ if } y = x, \quad 1/4 \text{ if } y = x \pm 1 \pmod 9, \quad 0 \text{ otherwise}.
$$

Start at site $0$: the distribution after $t$ steps is
$p\_t(y) = \mathbb{P}(X\_t = y \mid X\_0 = 0)$, the $t$-th row of the $t$-th
power. The target is the uniform distribution $\pi(y) = 1/9$, the natural
candidate because the walk is doubly stochastic. The distance: total
variation

$$
\mathrm{TV}(t) := \frac{1}{2} \sum\_y |p\_t(y) - \pi(y)|
$$

(the factor $1/2$ keeps it in $[0,1]$; the sum without the factor is the
$L^1$ distance and equals twice the maximum over sets $A$ of
$\mathbb{P}(X\_t \in A) - \pi(A)$; tag that duality as a named premise,
provable by choosing $A = \lbrace y : p\_t(y) > \pi(y)\rbrace$, the maximizing set,
since mass above the target on the complement is compensated below it).

The question: the smallest $t$ with $\mathrm{TV}(t) \le 1/4$ for every
start. By rotational equivalence every start gives the same
$\mathrm{TV}(t)$ (shifting the cycle shifts both $p\_t$ and $\pi$; the
difference $|p\_t - \pi|$ is translation-invariant, named symmetry
exhibited), so one start suffices.

## 2. The raw contraction: correct, useless for the rate

The averaging operator is exactly the convex-average map of
case-max-principle.md section 4:
$(Pf)(x) = \frac{1}{2}f(x) + \frac{1}{4}f(x+1) + \frac{1}{4}f(x-1)$, a convex
combination, so $\max |Pf| \le \max |f|$ and, applied to $f = p - \pi$
with max principle to $f$ and $-f$, $L^1$ distance is nonincreasing
across steps (monotonicity, PROVEN there and cited). This certifies that
the walk approaches $\pi$ but gives no speed: the max principle is the
Chebyshev bound of this setting. To read the rate we need the spectrum,
exactly as case-large-deviations.md section 5 needed the mgf.

## 3. The spectrum, via Fourier characters

The cycle invites trigonometry. Define characters
$\chi\_j(x) = \exp(2\pi i j x / 9)$ for $j = 0, \dots, 8$, complex
exponentials built from the eigenfunctions of the translation operators.
Action of $P$:

$$
(P \chi\_j)(x) = \sum\_y P(x,y) \chi\_j(y)
= \frac{1}{2}\chi\_j(x) + \frac{1}{4}\chi\_j(x+1) + \frac{1}{4}\chi\_j(x-1)
$$

(each nonzero transition weight written out; indices mod $9$). The
exponential functional equation
$\exp(2\pi i j (x \pm 1)/9) = \chi\_j(x) \exp(\pm 2\pi i j/9)$ (named
exponent law, the definition of the exponential on the unit circle).
Hence

$$
(P \chi\_j)(x) = \chi\_j(x)\Bigl[\frac{1}{2} + \frac{1}{4}(e^{2\pi i j/9} + e^{-2\pi i j/9})\Bigr].
$$

The bracket: $e^{it} + e^{-it} = 2 \cos t$ (definition of cosine), so

$$
P \chi\_j = \Bigl[\frac{1 + \cos(2\pi j/9)}{2}\Bigr] \chi\_j = \cos^2(\pi j/9)\  \chi\_j,
$$

the last step the double-angle identity $(1 + \cos 2t)/2 = \cos^2 t$.
So each character is an eigenvector with eigenvalue
$\lambda\_j = \cos^2(\pi j/9)$: nine eigenvalues, all real, all in $[0,1]$.

Linearly independent: the characters are mutually orthogonal since
$\sum\_x \chi\_j(x) \overline{\chi\_k}(x) = \sum\_x e^{2\pi i (j-k)x/9} = 9$
if $j = k$ (nine copies of 1) and for $j \ne k$ a geometric sum with
ratio $\omega \ne 1$ and $\omega^9 = 1$, hence
$(1 - \omega^9)/(1 - \omega) = 0$. (Geometric formula justified as in
case-ewma.md section 2, applied to a complex ratio; the ordinary one-name
rule above is the $N=9$ case.) Nine orthogonal nonzero vectors in
dimension 9 form a basis (orthogonal nonzero vectors are linearly
independent: named linear-algebra premise). PROVEN: the full spectrum of
$P$ is exactly $\lbrace\cos^2(\pi j/9) : j = 0, \dots, 8\rbrace$.

The gap: $\lambda\_0 = 1$ (eigenvalue of $\pi$). The largest nontrivial
one in modulus: $\cos^2(\pi/9)$ at $j = 1$ and $j = 8$, since for
$j \ne 0$ the angle $\pi j/9$ has distance at least $\pi/9$ from a
multiple of $\pi$ and cosine decreases on $[0, \pi/2]$ while squaring
folds the sign, hence $|\cos(\pi j/9)| \le \cos(\pi/9)$ (the extremal
cases enumerated: the angles nearest 0 or $\pi$). Set
$\lambda\_2 := \cos^2(\pi/9) \approx 0.8829$ and
$\gamma := 1 - \lambda\_2 = \sin^2(\pi/9) \approx 0.1170$ (the same
double-angle identity). For $n$ sites the same computation gives
$\lambda\_2 = \cos^2(\pi/n)$: the parity trap. If $n$ is even the walk
without holding still alternates and mixes in no way; holding is what
bought aperiodicity. State it: every eigenvalue above stays in $[0,1]$,
so laziness removed the $-1$ that an even non-lazy cycle carries.

## 4. Chi-square decay and the TV bound

Deviation $f := p\_t - \pi$, a real vector with sum 0. Expand the starting
deviation in the orthonormal basis $\psi\_j := \chi\_j/\sqrt{9}$ (the
orthogonality constants of section 3: $\sum\_x |\psi\_j|^2 = 1$):

$$
P^t f = \sum\_j \lambda\_j^t b\_j \psi\_j, \qquad b\_j := \langle f, \psi\_j \rangle.
$$

(Each step: diagonalization = write the vector in the eigenbasis and
act on each basis element by the eigenvalue; $P^t$ has eigenvalues
$\lambda\_j^t$ because powers of diagonal form, named.) The $j = 0$
coefficient $b\_0$ vanishes: $\langle f, \psi\_0 \rangle = \sum\_x f(x)/3 = 0$
because $p\_t$ and $\pi$ both sum to 1 (named check). Parseval (the same
orthogonality identities, squared):
$\lVert P^t f\rVert^2 = \sum\_{j>0} \lambda\_j^{2t} |b\_j|^2 \le \lambda\_2^{2t} \sum\_{j>0} |b\_j|^2 = \lambda\_2^{2t} \lVert f\rVert^2$,
each $\lambda\_j$ in $[0, \lambda\_2]$ used once, under the squaring the
ordering is preserved (monotone square on nonnegatives, named).

Chi-square distance to $\pi$: $\chi^2 := \sum\_y (p\_t(y) - \pi(y))^2/\pi(y)$.
With $\pi = 1/9$:
$\chi^2 = 9 \lVert p\_t - \pi\rVert^2 \le 9 \lambda\_2^{2t} \lVert p\_0 - \pi\rVert^2$
where $p\_0$ is the delta at $0$. The initial contribution:
$\lVert\delta\_0 - \pi\rVert^2 = (1 - 1/9)^2 + 8(1/9)^2$ (one site carries 1 and
the other eight carry 0 against $\pi = 1/9$, expanded)
$= 64/81 + 8/81 = 72/81 = 8/9$. Therefore

$$
\chi^2(t) \le 8 \lambda\_2^{2t} = 8 \cos^{4t}(\pi/9).
$$

TV from chi-square:
$\mathrm{TV} = \frac{1}{2} \sum\_y |f(y)| = \frac{1}{2} \sum\_y (|f(y)|/\sqrt{\pi(y)}) \sqrt{\pi(y)}$
and Cauchy-Schwarz (inner product of the vectors $(|f|/\sqrt{\pi})\_y$ and
$(\sqrt{\pi})\_y$, named with the formula
$\sum a\_y b\_y \le \sqrt{\sum a\_y^2} \sqrt{\sum b\_y^2}$):

$$
\mathrm{TV} \le \frac{1}{2} \sqrt{\sum\_y f(y)^2/\pi(y)} \sqrt{\sum\_y \pi(y)}
= \frac{1}{2} \sqrt{\chi^2}.
$$

PROVEN chain:
$\mathrm{TV}(t) \le \frac{1}{2} \sqrt{8}\  \lambda\_2^t = \sqrt{2} \cos^{2t}(\pi/9)$.

## 5. The mixing-time certificate, complete

Target $\mathrm{TV} \le 1/4$. It suffices that
$\frac{1}{2} \sqrt{8}\  \lambda\_2^t \le 1/4$. Clean the arithmetic:
$\frac{1}{2} \sqrt{8} = \sqrt{2}$ and $\sqrt{2}\  \lambda\_2^t \le 1/4$
means $\lambda\_2^t \le 1/(4 \sqrt{2})$ (multiply by $1/\sqrt{2}$,
preserving order, both sides positive). Take logs (log increasing, both
sides positive): $t \ln \lambda\_2 \le -\ln(4 \sqrt{2})$. Now
$\ln \lambda\_2 < 0$ ($\lambda\_2 < 1$), division flips, and the tangent
inequality $\ln \lambda\_2 \le \lambda\_2 - 1 = -\gamma$ (proved in
case-gibbs.md section 2, applied at $x = \lambda\_2$) gives
$-1/\ln \lambda\_2 \le 1/\gamma$. Sufficient therefore

$$
t \ge \ln(4 \sqrt{2})/\gamma = \ln(5.657)/0.1170 = 1.7329/0.1170 = 14.8,
$$

so $t = 15$ steps certify $\mathrm{TV}(15) \le 1/4$. PROVEN: the bound
follows with $\gamma = \sin^2(\pi/9)$; the decimal evaluation of
$\sin(\pi/9) = 0.3420$ and the logarithm come from a standard table, and
the inequality chain above never uses more precision than monotonicity.
The $n$-site statement: $\gamma = \sin^2(\pi/n)$ and
$t \ge \ln(4 \sqrt{2})/\sin^2(\pi/n) \approx 1.73 n^2/\pi^2 \approx 0.18 n^2$
since $\sin x \sim x$ shows the $n^2$ diffusion timescale. This is the
discrete shadow of the heat-kernel case: the graph Laplacian of the
cycle has eigenvalues $1 - \cos(2\pi j/n)$, whose first one is
$1 - \cos(2\pi/n) \approx 2\pi^2/n^2$, the same $n^2$ scale (both gaps
differ by exact constants only).

### Bend certificate scope

`bend/LAWS.bend#chi_tv_transfer_rat` certifies the finite rational inequality
$(\sum |p\_i-u\_i|)^2 \le (\sum u\_i) \cdot \sum (|p\_i-u\_i|^2/u\_i)$ for strictly positive
rational `u_i`. Its proof uses weighted sums of nonnegative squares and exact
positive division. The original real-valued `Real.sqrt` goal remains open;
this certificate does not formalize the spectral, exponential, or logarithmic
steps elsewhere in this case. See `bend/README.md` and `bend/OPEN.md`.

## 6. Fixtures recomputed

Exact two-step distribution from equation 1 (start 0, arithmetic by hand):
$p\_2(0) = (1/2)(1/2) + (1/4)(1/4) + (1/4)(1/4) = 1/4 + 1/16 + 1/16 = 3/8$;
$p\_2(\pm 1) = (1/2)(1/4) + (1/4)(1/2) = 1/8 + 1/8 = 1/4$ (each path
articulated: stay then move, move then stay); $p\_2(\pm 2) = (1/4)(1/4) = 1/16$;
$p\_2$ others $= 0$. With $\pi = 1/9$,

$$
\mathrm{TV}(2) = \frac{1}{2}\Bigl[|3/8 - 1/9| + 2|1/4 - 1/9| + 2|1/16 - 1/9| + 4|0 - 1/9|\Bigr].
$$

Common denominator 72: $|3/8 - 1/9| = 19/72$; $|1/4 - 1/9| = 5/36 = 10/72$,
doubled: $20/72$; $|1/16 - 1/9| = 7/144$, doubled: $7/72$;
$|0 - 1/9| = 8/72$, four sites: $32/72$. Total inside:
$19 + 20 + 7 + 32 = 78$; half: $\mathrm{TV}(2) = 39/72 = 13/24 = 0.5417$.
SUPPORTED by exact single-sheet arithmetic.

Iterated row powers (the recursion of section 1, nine numbers carried,
computed by a 9-state iteration described above): $t = 5$: $0.3351$,
$t = 10$: $0.1838$, $t = 15$: $0.0990$, $t = 28$: $0.0196$,
$t = 29$: $0.0173$. The certificate guarantees mixing by $t = 15$: the
direct bound $\frac{1}{2} \sqrt{8}\  \lambda\_2^{15} = 0.2185 \le 1/4$
($\lambda\_2^{15} = 0.1545$ from a log table), and the looser
tangent-inequality version from the preceding paragraph gives
$\frac{1}{2} \sqrt{8}\  e^{-15 \gamma} = 0.2447 \le 1/4$. The measured
distance at $t = 15$ is $0.0990$: the bound is safe by a constant factor
of about 2, because it spent only $\lambda\_2$ and waved away the rest of
the spectrum. The same tolerance between guaranteed and true rates
appeared in case-large-deviations.md section 4: a rate is logarithmic
truth; the constants belong to the finer theory below.

## 7. Where the frontier is

- Cutoff: the true TV decays on the scale $n^2/\pi^2$ times log factors,
  and the transition happens within a window of a lower order; proving
  it needs all eigenvalues plus the multiplicities of the leading ones
  (Diaconis-Aldous; cited). The $\lambda\_2$-only bound of this file is the
  relaxation half of the story, not the whole window.
- Lower bounds: a matching claim $\mathrm{TV}(t)$ stays near 1 below the
  cutoff needs an eigenfunction test function (the exhibition of a slowly
  relaxing observable), cited.
- Cheeger inequalities bind the gap to bottlenecks for arbitrary
  reversible chains; log-Sobolev constants replace the gap for spin
  systems (the Gibbs states of case-gibbs.md) at low temperature, cited.
- Markov chain Monte Carlo: Metropolis proposals accepted by exactly
  the Gibbs tilt of case-gibbs.md section 5, so this case is the
  correctness engine behind every sampler of the Gibbs case.
