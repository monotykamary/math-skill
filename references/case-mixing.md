# Case study: how long until a Markov chain forgets its start

The threshold question of case-ewma.md, asked in probabilistic form. The
object is a lazy random walk on a cycle of nine sites. The engine is the
same one that ran case-heat-kernel.md: symmetrize, take the spectrum, read
the second eigenvalue as the forgetting rate. The mixing time bound follows
from one Cauchy-Schwarz inequality and one tangent inequality. Every step
is named; every threshold number is recomputed.

## 1. The chain and the distance

Cycle C_9 with sites 0..8 indexed mod 9. One step: stay with probability
1/2, move to each neighbor with probability 1/4. The transition matrix:

P(x,y) = 1/2 if y = x, 1/4 if y = x +- 1 (mod 9), 0 otherwise.

Start at site 0: the distribution after t steps is p_t(y) = P(X_t = y |
X_0 = 0), the t-th row of the t-th power. The target is the uniform
distribution pi(y) = 1/9, the natural candidate because the walk is
doubly stochastic. The distance: total variation

TV(t) := (1/2) sum_y |p_t(y) - pi(y)|

(the factor 1/2 keeps it in [0,1]; the sum without the factor is the L1
distance and equals twice the maximum over sets A of
P(X_t in A) - pi(A); tag that duality as a named premise, provable by
choosing A = {y : p_t(y) > pi(y)}, the maximizing set, since mass above
the target on the complement is compensated below it).

The question: the smallest t with TV(t) <= 1/4 for every start. By
rotational equivalence every start gives the same TV(t) (shifting the
cycle shifts both p_t and pi; the difference |p_t - pi| is
translation-invariant, named symmetry exhibited), so one start suffices.

## 2. The raw contraction: correct, useless for the rate

The averaging operator is exactly the convex-average map of
case-max-principle.md section 4: (Pf)(x) = (1/2)f(x) + (1/4)f(x+1)
+ (1/4)f(x-1), a convex combination, so max|Pf| <= max|f| and, applied
to f = p - pi with max principle to f and -f, L1 distance is
nonincreasing across steps (monotonicity, PROVEN there and cited). This
certifies that the walk approaches pi but gives no speed: the max
principle is the Chebyshev bound of this setting. To read the rate we
need the spectrum, exactly as case-large-deviations.md section 5 needed
the mgf.

## 3. The spectrum, via Fourier characters

The cycle invites trigonometry. Define characters chi_j(x) =
exp(2 pi i j x / 9) for j = 0..8, complex exponentials built from the
eigenfunctions of the translation operators. Action of P:

(P chi_j)(x) = sum_y P(x,y) chi_j(y)
  = (1/2) chi_j(x) + (1/4) chi_j(x+1) + (1/4) chi_j(x-1)

(each nonzero transition weight written out; indices mod 9). The
exponential functional equation exp(2 pi i j (x+-1)/9) =
chi_j(x) exp(+-2 pi i j /9) (named exponent law, the definition of the
exponential on the unit circle). Hence

(P chi_j)(x) = chi_j(x) [1/2 + (1/4)(e^{2 pi i j /9} + e^{-2 pi i j /9})].

The bracket: e^{i t} + e^{-i t} = 2 cos t (definition of cosine), so

P chi_j = [(1 + cos(2 pi j / 9))/2] chi_j = cos^2(pi j / 9) chi_j,

the last step the double-angle identity (1 + cos 2t)/2 = cos^2 t.
So each character is an eigenvector with eigenvalue lambda_j =
cos^2(pi j/9): nine eigenvalues, all real, all in [0,1].

Linearly independent: the characters are mutually orthogonal since
sum_{x} chi_j(x) overline(chi_k)(x) = sum_x e^{2 pi i (j-k) x/9}
= 9 if j = k (nine copies of 1) and for j != k a geometric sum with
ratio omega != 1 and omega^9 = 1, hence (1 - omega^9)/(1 - omega) = 0.
(Geometric formula justified as in case-ewma.md section 2, applied to a
complex ratio; the ordinary one-name rule above is the N=9 case.)
Nine orthogonal nonzero vectors in dimension 9 form a basis (orthogonal
nonzero vectors are linearly independent: named linear-algebra premise).
PROVEN: the full spectrum of P is exactly {cos^2(pi j/9) : j = 0..8}.

The gap: lambda_0 = 1 (eigenvalue of pi). The largest nontrivial one in
modulus: cos^2(pi/9) at j = 1 and j = 8, since for j != 0 the angle
pi j/9 has distance at least pi/9 from a multiple of pi and cosine
decreases on [0, pi/2] while squaring folds the sign, hence
|cos(pi j/9)| <= cos(pi/9) (the extremal cases enumerated: the angles
nearest 0 or pi). Set lambda2 := cos^2(pi/9) ~ 0.8829 and
gamma := 1 - lambda2 = sin^2(pi/9) ~ 0.1170 (the same double-angle
identity). For n sites the same computation gives lambda2 = cos^2(pi/n):
the parity trap. If n is even the walk without holding still alternates
and mixes in no way; holding is what bought aperiodicity. State it:
every eigenvalue above stays in [0,1], so laziness removed the -1 that
an even non-lazy cycle carries.

## 4. Chi-square decay and the TV bound

Deviation f := p_t - pi, a real vector with sum 0. Expand the starting
deviation in the orthonormal basis psi_j := chi_j/sqrt(9) (the
orthogonality constants of section 3: sum_x |psi_j|^2 = 1):

P^t f = sum_j lambda_j^t b_j psi_j,  b_j := <f, psi_j>.

(Each step: diagonalization = write the vector in the eigenbasis and
act on each basis element by the eigenvalue; P^t has eigenvalues
lambda_j^t because powers of diagonal form, named.) The j = 0
coefficient b_0 vanishes: <f, psi_0> = sum_x f(x)/3 = 0 because p_t
and pi both sum to 1 (named check). Parseval (the same orthogonality
identities, squared): ||P^t f||^2 = sum_{j>0} lambda_j^{2t} |b_j|^2
<= lambda2^{2t} sum_{j>0} |b_j|^2 = lambda2^{2t} ||f||^2, each lambda_j
in [0, lambda2] used once, under the squaring the ordering is preserved
(monotone square on nonnegatives, named).

Chi-square distance to pi: chi^2 := sum_y (p_t(y) - pi(y))^2/pi(y).
With pi = 1/9: chi^2 = 9 ||p_t - pi||^2 <= 9 lambda2^{2t} ||p_0 - pi||^2
where p_0 = the delta at 0. The initial contribution:
||delta_0 - pi||^2 = (1 - 1/9)^2 + 8(1/9)^2 (one site carries 1 and
the other eight carry 0 against pi = 1/9, expanded) = 64/81 + 8/81
= 72/81 = 8/9. Therefore

chi^2(t) <= 8 lambda2^{2t} = 8 cos^{4t}(pi/9).

TV from chi-square: TV = (1/2) sum_y |f(y)|
= (1/2) sum_y (|f(y)|/sqrt(pi(y))) sqrt(pi(y)) and Cauchy-Schwarz
(inner product of the vectors (|f|/sqrt(pi))_y and (sqrt(pi))_y, named
with the formula sum a_y b_y <= sqrt(sum a_y^2) sqrt(sum b_y^2)):

TV <= (1/2) sqrt(sum_y f(y)^2/pi(y)) sqrt(sum_y pi(y))
= (1/2) sqrt(chi^2).

PROVEN chain: TV(t) <= (1/2) sqrt(8) lambda2^t = sqrt(2) cos^{2t}(pi/9).

## 5. The mixing-time certificate, complete

Target TV <= 1/4. It suffices that (1/2) sqrt(8) lambda2^t <= 1/4.
Clean the arithmetic: (1/2) sqrt(8) = sqrt(2) and sqrt(2) lambda2^t <= 1/4
means lambda2^t <= 1/(4 sqrt(2)) (multiply by 1/sqrt(2), preserving order,
both sides positive). Take logs (log increasing, both sides
positive): t ln lambda2 <= -ln(4 sqrt(2)). Now ln lambda2 < 0
(lambda2 < 1), division flips, and the tangent inequality
ln lambda2 <= lambda2 - 1 = -gamma (proved in case-gibbs.md section 2,
applied at x = lambda2) gives -1/ln lambda2 <= 1/gamma. Sufficient
therefore

t >= ln(4 sqrt(2))/gamma = ln(5.657)/0.1170 = 1.7329/0.1170 = 14.8,

so t = 15 steps certify TV(15) <= 1/4. PROVEN: the bound follows with
gamma = sin^2(pi/9); the decimal evaluation of sin(pi/9) = 0.3420 and
the logarithm come from a standard table, and the inequality chain above
never uses more precision than monotonicity. The n-site statement:
gamma = sin^2(pi/n) and t >= ln(4 sqrt(2))/sin^2(pi/n) ~ 1.73 n^2/pi^2
~ 0.18 n^2 since sin x ~ x shows the n^2 diffusion timescale. This is
the discrete shadow of the heat-kernel case: the graph Laplacian of the
cycle has eigenvalues 1 - cos(2 pi j/n), whose first one is
1 - cos(2 pi/n) ~ 2 pi^2/n^2, the same n^2 scale (both gaps differ by
exact constants only).

## 6. Fixtures recomputed

Exact two-step distribution from equation 1 (start 0, arithmetic by
hand): p_2(0) = (1/2)(1/2) + (1/4)(1/4) + (1/4)(1/4) = 1/4 + 1/16
+ 1/16 = 3/8; p_2(+-1) = (1/2)(1/4) + (1/4)(1/2) = 1/8 + 1/8 = 1/4
(each path articulated: stay then move, move then stay);
p_2(+-2) = (1/4)(1/4) = 1/16; p_2 others = 0. With pi = 1/9,
TV(2) = (1/2)[|3/8 - 1/9| + 2|1/4 - 1/9| + 2|1/16 - 1/9| + 4|0 - 1/9|].
Common denominator 72: |3/8 - 1/9| = 19/72; |1/4 - 1/9| = 5/36 = 10/72,
doubled: 20/72; |1/16 - 1/9| = 7/144, doubled: 7/72; |0 - 1/9| = 8/72,
four sites: 32/72. Total inside: 19 + 20 + 7 + 32 = 78; half:
TV(2) = 39/72 = 13/24 = 0.5417. SUPPORTED by exact single-sheet
arithmetic.

Iterated row powers (the recursion of section 1, nine numbers carried,
computed by a 9-state iteration described above): t = 5: 0.3351,
t = 10: 0.1838, t = 15: 0.0990, t = 28: 0.0196, t = 29: 0.0173.
The certificate guarantees mixing by t = 15: the direct bound
(1/2) sqrt(8) lambda2^15 = 0.2185 <= 1/4 (lambda2^15 = 0.1545 from a
log table), and the looser tangent-inequality version from the
preceding paragraph gives (1/2) sqrt(8) e^{-15 gamma} = 0.2447 <= 1/4.
The measured distance at t = 15 is 0.0990: the bound is safe by a
constant factor of about 2, because it spent only lambda2 and waved
away the rest of the spectrum. The same tolerance between guaranteed
and true rates appeared in case-large-deviations.md section 4: a rate
is logarithmic truth; the constants belong to the finer theory below.

## 7. Where the frontier is

- Cutoff: the true TV decays on the scale n^2/pi^2 times log factors,
  and the transition happens within a window of a lower order; proving
  it needs all eigenvalues plus the multiplicities of the leading ones
  (Diaconis-Aldous; cited). The lambda2-only bound of this file is the
  relaxation half of the story, not the whole window.
- Lower bounds: a matching claim TV(t) stays near 1 below the cutoff
  needs an eigenfunction test function (the exhibition of a slowly
  relaxing observable), cited.
- Cheeger inequalities bind the gap to bottlenecks for arbitrary
  reversible chains; log-Sobolev constants replace the gap for spin
  systems (the Gibbs states of case-gibbs.md) at low temperature, cited.
- Markov chain Monte Carlo: Metropolis proposals accepted by exactly
  the Gibbs tilt of case-gibbs.md section 5, so this case is the
  correctness engine behind every sampler of the Gibbs case.
