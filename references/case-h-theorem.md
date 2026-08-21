# Case study: the H-theorem on a finite grid, proved completely

Kinetic theory case #1, closing the hole in the declared territory. The
full Boltzmann equation needs triple collision integrals, but its engine
is one algebraic identity that a finite grid exhibits completely:
every symmetric transfer between two cells moves entropy upward, and
nothing else matters. The file proves the grid version with no citing,
then says precisely which steps carry to Boltzmann and which do not.

## 1. The model

N cells, counts n_i >= 0, sum n_i = 1 after normalization (the mass is
one particle, and the master equation below conserves it). Matter
transfers between cells i and j at symmetric rates: k_{ij} = k_{ji}
>= 0 (microscopic reversibility; on a connected graph, paths exist
between any two cells). The master equation:

dn_i/dt = sum_j k_{ij} n_j - sum_j k_{ji} n_i.

First term: influx into i from every j at rate k_{ij} (the rate of the
j -> i channel times the mass at j). Second: efflux from i to every j
at rate k_{ji}. Since k is symmetric, rewrite as a single sum of
pairwise transfers:

dn_i/dt = sum_j k_{ij}(n_j - n_i).

Each channel contributes its signed exchange. The equation conserves
mass: sum_i dn_i/dt = sum_{i,j} k_{ij}(n_j - n_i) = 0, because the
double sum is antisymmetric under the label swap i <-> j: rename i as
j in the first part (valid since the sum ranges over all pairs) and
the symmetry k_{ji} = k_{ij} leaves sum k_{ij} n_i; the two parts
cancel termwise. PROVEN, mass is conserved along the flow.

## 2. Entropy and its derivative

S := -sum_i n_i ln n_i, with 0 ln 0 := 0 as in case-gibbs.md section 1,
where the convention is argued. The chain rule on the t-derivative
(factored in every term shown):

dS/dt = -sum_i (d n_i/dt) ln n_i - sum_i d n_i/dt.

The second sum is zero by mass conservation just proven. The first:
substitute the pairwise form and symmetrize, the classic move the
course has used since case-kelly.md section 2 (log of a product split
into a sum of logs):

dS/dt = -sum_{i,j} k_{ij}(n_j - n_i) ln n_i
      = -(1/2) sum_{i,j} k_{ij}[(n_j - n_i) ln n_i + (n_i - n_j) ln n_j]

where the second line replaces the whole sum by its own label-swapped
copy averaged with it (renaming i <-> j in the double sum changes
nothing: the summation ranges over all pairs either way; k symmetric
as named). Combine:

dS/dt = (1/2) sum_{i,j} k_{ij} (n_j - n_i)(ln n_j - ln n_i) >= 0.

The inequality: ln is increasing, so the factors (n_j - n_i) and
(ln n_j - ln n_i) have the same sign (monotone functions preserve
order; each named for the pair), their product is nonnegative, and
k_{ij} >= 0 carries it.  Equality across the sum exactly when every
active channel has n_i = n_j (each nonnegative term vanishes), and on
a connected graph that happens exactly at the uniform distribution
(equality propagates along paths from any cell to every other, one
edge at a time). PROVEN completely:

THE H-THEOREM (grid): arbitrary initial mass flows to make S
nondecreasing, with a strict increase while any active channel carries
a difference; the only stationary non-wasting state is uniform.

## 3. What this has to do with Boltzmann

Boltzmann's continuous H = integral f ln f dv with the binary
collision gain-loss term is the same proof shape: the antisymmetry
creating the cancellation is the collision kernel's microreversibility
(stated as elasticity and time-reversal symmetry), and the
two-variable symmetrization above is the same averaging over a pair.
Two additional burdens appear there live: the kernel carries
pre-collisional velocities as arguments of f at four points, and the
cancellation producing (ln a - ln b)(a - b) requires the chain of
collision-invariance identities. Those burdens are carried in the
standard proof but not re-derived here (tag GAP; the grid identity
above is the intact core). What the grid does NOT need and Boltzmann
must earn: conservation of the three invariants 1, v, |v|^2 along
collisions (the integrals that pin the Maxwellian). State them for the
record: entropy maximized at fixed mass, momentum, and energy means by
case-gibbs.md section 3 that the equilibrium is exponential in the two
collision-preserved quantities, precisely the tilted measure of
section 5 there read in velocity space: f_eq(v) = C exp(-beta |v - u|^2),
the Maxwellian. The connection is one line long because the Gibbs case
did the work already; it is labeled as the cited bridge, not a fresh
proof.

## 4. The two-cell trajectory, computed completely

Cells 1 and 2, k = 1/2. With n_1 + n_2 = 1:
dn_1/dt = (1/2)(n_2 - n_1). The difference Delta := n_1 - n_2
subtracts its own equation: dDelta/dt = dn_1/dt - dn_2/dt
= (1/2)(n_2 - n_1) - (1/2)(n_1 - n_2) = -(n_1 - n_2) = -Delta.
This is the one-cell contraction of case-heat-kernel.md section 2 in
exact miniature: Delta(t) = Delta(0) e^{-t} (closed form by the same
uniqueness cited there), hence

n_1(t) = (1 + e^{-t})/2, n_2(t) = (1 - e^{-t})/2 from n_1(0) = 1.

PROVEN. Entropy along the flow, both routes; route one is the formula
of section 2 evaluated: dS/dt = k (n_1 - n_2)(ln n_1 - ln n_2)
= (1/2)(n_1 - n_2)(ln n_1 - ln n_2) with k = 1/2
(take i,j = 1,2 in the symmetrized sum; the two labelings 1,2 and 2,1
carry the same product because both factors flip sign together, so the
(1/2) times the doubled term leaves exactly (1/2)(n_2 - n_1)(ln n_2 -
ln n_1), honest bookkeeping). Route two is direct difference S(t+1) - S(t)
at sample points: t = 0: S = 0 (one occupied cell: 1 ln 1 = 0 and the
convention at 0). t = 1: n_1 = 0.6839, n_2 = 0.3161,
S = -0.6839 ln(0.6839) - 0.3161 ln(0.3161)
= 0.6839 * 0.3799 + 0.3161 * 1.1518 = 0.2598 + 0.3641 = 0.6239.
t = 2: n_1 = 0.5677, n_2 = 0.4323,
S = 0.5677 * 0.5662 + 0.4323 * 0.8386 = 0.3214 + 0.3626 = 0.6840.
Limit: n -> 1/2, S -> ln 2 = 0.6931 (uniform, the Gibbs computation of
case-gibbs.md section 6 at beta = 0 special case). Monotone upward
0 < 0.6239 < 0.6840 < 0.6931. SUPPORTED by hand-table logarithms at
the two cut points (t = 1, 2), the limit value PROVEN as the uniform
entropy. Note e^{-1} = 0.3679 and e^{-2} = 0.1353 from the exponential
table carry the n values: n_1(1) = (1 + 0.3679)/2 and
n_1(2) = (1 + 0.1353)/2, recomputed rather than trusted.

## 5. Method summary and ties

postulate-pairwise-symmetry -> derive one antisymmetric cancellation
-> the nonnegativity of (a - b)(ln a - ln b) -> strict increase off
equilibrium. One inequality, used twice in the course already (the
Gibbs tangent is its differential); here it is the whole mechanism.

The connections: the uniform equilibrium is maximum entropy under mass
only (case-gibbs.md section 1); the approach e^{-t} is the exponential
contraction rate of the two-cell heat flow (case-heat-kernel.md section
2 and case-ewma.md section 3 share the one-dimensional skeleton); and
the mixing case closes the loop on which rate, exactly, large grids
achieve (case-mixing.md computes lambda2 against its pi). The route
outward to turbulence: a cascade is a non-equilibrium steady state
with entropy flowing through it, the K41 setting where the H-theorem
applies at every scale but never relaxes globally (case-kolmogorov.md
section 5).

## 6. Where the frontier is

- Entropy-production inequalities: bounding dS/dt below by a multiple
  of the deficit S_eq - S for a linear master equation returns the
  spectral gap machinery of case-mixing.md (the sharp constant is the
  log-Sobolev constant of the graph, cited). For nonlinear Boltzmann
  this bound is the Cercignani program: dH/dt <= -const * (H - H_eq)
  holds in some regimes and fails in others, cited frontier.
- The route from discrete master equation to kinetic PDE is coarse
  graining in space and velocity; keeping entropy semantics intact
  under the limit is the modern entropy method program (cited).
- Landau/Fokker-Planck for Coulomb systems: the collision operator is
  reorganized as a diffusion in velocity with the same antisymmetric
  skeleton (cited).
