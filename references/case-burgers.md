# Case study: Burgers shocks, and the entropy condition that selects them

The hyperbolic contrast the course was missing. Every previous diffusion
case saw heat smooth things. Here the SAME heat equation organizes the
opposite picture: a wave steepens, a discontinuity forms at finish
gear, and the weak solution that survives is chosen by an entropy
inequality whose viscous bill is paid exactly at the shock. Tools:
Cole-Hopf, one Laplace limit, one tanh profile, unit-with-trailing
arithmetic. Ties: the heat kernel case supplies the engine; the
large-deviations case supplies the soft-min-to-min limit that converts
it into the inviscid answer.

## 1. Two equations and what the name says

Viscous Burgers: u_t + u u_x = nu u_xx. Inviscid Burgers:
u_t + u u_x = 0. The inviscid one is a conservation law with flux
f(u) = u^2/2 (u_t + f(u)_x = 0 since f'(u) = u and the chain rule,
named). The viscous one is the heat flow dressed in a nonlinear
transport: the Laplacian term is ready to smooth, the flux term is
ready to steepen. Both claims are checked in the fixtures below, where
one term at a time has its way.

## 2. Cole-Hopf: Burgers is heat in log coordinates

Claim: if phi is any positive solution of the heat equation
phi_t = nu phi_xx, then u := -2 nu (ln phi)_x = -2 nu phi_x/phi solves
viscous Burgers. Proof by direct substitution, every derivative shown.
From u = -2 nu phi_x/phi:

u_t = -2 nu (phi_xt phi - phi_x phi_t)/phi^2 (quotient rule),
u_x = -2 nu (phi_xx phi - phi_x^2)/phi^2 (quotient rule),
u_xx = -2 nu (phi_xxx/phi - 3 phi_xx phi_x/phi^2 + 2 phi_x^3/phi^3)

(the second quotient: the derivative of phi_xx/phi contributes
phi_xxx/phi - phi_xx phi_x/phi^2 and the derivative of phi_x^2/phi^2
contributes 2 phi_x phi_xx/phi^2 - 2 phi_x^3/phi^3, summed). Pair the
flux term with the Laplacian term before summing:

u u_x - nu u_xx = 4 nu^2 phi_x phi_xx/phi^2 - 4 nu^2 phi_x^3/phi^3
 + 2 nu^2 phi_xxx/phi - 6 nu^2 phi_xx phi_x/phi^2 + 4 nu^2 phi_x^3/phi^3
= 2 nu^2 phi_xxx/phi - 2 nu^2 phi_xx phi_x/phi^2

(the two cubed terms cancel: -4 + 4 = 0, and the mixed terms sum
against each other). Then

u_t + u u_x - nu u_xx = -2 nu phi_xt/phi + 2 nu phi_t phi_x/phi^2
 + 2 nu^2 phi_xxx/phi - 2 nu^2 phi_xx phi_x/phi^2,
which is exactly -2 nu times the x-derivative of (phi_t - nu phi_xx)/phi
(the quotient rule on that ratio, expanded, returns the same four
terms in the same order). Since phi solves the heat equation, the bracket vanishes,
and the combination above is identically zero. PROVEN.

Sufficiency is all the course needs; the converse direction (any
Burgers solution arises this way up to gauge) follows because the
same derivative computation has to be read backward: the equation
u solves forces (phi_t - nu phi_xx)/phi = f(t) for a free function f,
and replacing phi by phi exp(-integral f) keeps u unchanged while
clearing f (the gauge change commutes with -2 nu ln-differentiation
because the added factor contributes only a t-function). PROVEN with
the gauge argument stated.

## 3. The inviscid limit is a soft-min becoming a min

Fix the transformation at initial time: u(x,0) = u_0(x) picks
phi(0,x) = exp(-Phi_0(x)/(2 nu)) with Phi_0_x = u_0 (integrate u_0
once; the additive constant is gauge and cancels in u). The heat
kernel of case-heat-kernel.md section 2 and case-black-scholes.md
section 5 then gives

phi(t,x) = constant * integral exp(-[Phi_0(y) + (x-y)^2/(2t)]/(2 nu)) dy,

each ingredient named: the kernel is the Gaussian with variance 2 nu t
(the same completion that closed case-large-deviations.md section 4),
and the integral starts from the exponential of the initial data.
Take -2 nu ln of both sides and let nu -> 0. For the QUADRATIC
profiles below the limit is computable with the completion-of-squares
alone, so the course can show the passage without citing the general
Laplace principle:

min over y of [Phi_0(y) + (x-y)^2/(2t)]

enters through -2 nu ln integral -> min: evaluate the Gaussian integral
for a quadratic exponent exactly (the completed square pins the center
y* and the width shrinks like sqrt(nu), the prefactor contributes
nu ln nu -> 0 by the archimedean comparison of
case-ewma.md section 3 pace), so the log picks the smallest exponent
value while all other mass dies relative to it. PROVEN in the
quadratic instance, and this instance is the Hopf-Lax formula:

u(t,x) = d/dx min_y [Phi_0(y) + (x-y)^2/(2t)]).

The same soft-min-to-min exchange is the Laplace principle of
case-large-deviations.md: a min conversation in exact parallel with the
Legendre sup the course already runs there. State the pairing once.

## 4. Expansion never shocks: an explicit profile

u_0(x) = x (linear expansion, Phi_0 = x^2/2). The minimizer solves
the first-order condition y = x/(1+t) (differentiate y^2/2 +
(x-y)^2/(2t): derivative y - (x-y)/t zeroed gives y(1+t) = x, the
named step). The minimized value:

(x)^2 handled at the minimizer: y^2/2 + (x-y)^2/(2t) at y = x/(1+t)
= x^2/(2(1+t)^2) + (x - x/(1+t))^2/(2t)
= x^2/(2(1+t)^2) + x^2 t^2/(2t(1+t)^2)
= x^2(1+t)/(2(1+t)^2) = x^2/(2(1+t)),

(collect the common denominator (1+t)^2 term by term). Hence
u(t,x) = x/(1+t). Check the viscous equation directly:
u_t = -x/(1+t)^2, u_x = 1/(1+t), u_xx = 0, u u_x = x/(1+t)^2, so
u_t + u u_x = 0 = nu u_xx: the explicit flow satisfies the viscous
equation too, identically, at every nu. PROVEN: expansion is a genuine
solution for all viscosities. Smooth forever; characteristics spread;
no shock can form from this datum, and the heat layer has nothing to
smooth because the Laplacian of this profile vanishes.

## 5. Compression forms a shock at a computable time

u_0(x) = -x: characteristics dx/dt = u start at slope -1 and contract
linearly; the first crossing time t* is the breaking time of -1/(1-t).
The soft-min route: the exponent y -> -y^2/2 + (x-y)^2/(2t) has the
y^2 coefficient (-1/2 + 1/(2t)) = (1-t)/(2t), positive for t < 1, and
its minimizer solves -y + (y-x)/t = 0, that is y = x/(1-t). The
minimized value -x^2/(2(1-t)) gives the candidate u(t,x) =
-x/(1-t) (same substitution arithmetic as section 4 with the sign
tracked through). Check against the inviscid equation directly:
u_t = -x/(1-t)^2, u_x = -1/(1-t), uu_x = x/(1-t)^2: the flux balances
the time slice, a genuine classical inviscid solution with the profile
steepening like -1/(1-t): the derivative u_x -> -infinity as t
approaches 1 from below. PROVEN: gradient blow-up at t* = 1, the
shock time. For t > 1 the soft-min quadratic has negative curvature
(the y^2 coefficient (1-t)/(2t) is negative): no minimizer exists, the
Laplace integral itself leaves the heat-solvable regime (the initial
phi = exp(y^2/(4 nu)) grows faster than the kernel decays), and the
smooth picture is dead: the trajectory continues as a weak solution.
Both escapes are named; neither is spun.

## 6. Weak solutions and the entropy condition, on one jump

A piecewise constant profile u = u_l for x < 0, u = u_r for x > 0 is a
weak solution moving with speed s exactly when the Rankine-Hugoniot
jump condition holds: s = (f(u_l) - f(u_r))/(u_l - u_r)
= (u_l + u_r)/2 for the Burgers flux f = u^2/2 (the difference
u_l^2 - u_r^2 = (u_l - u_r)(u_l + u_r), factored). Derivation: plug
the traveling jump into the weak form: for every smooth compact test
phi, the identity integral (u phi_t + f(u) phi_x) = 0 forces the
boundary contributions along the jump to balance, and the balance
statement is exactly the flux difference times the normal component;
verified by the direct substitution for the jump below (the general
balance is the same one used to define weak solutions; state the weak
form first; the fact follows by the divergence theorem restricted to
the two half-planes).

The entropy condition: for an admissible shock, characteristics must
enter it, u_l > s > u_r, which for Burgers means u_l > u_r. Take the
stationary jump u_l = 1, u_r = -1: s = (1 + (-1))/2 = 0 and
u_l = 1 > 0 > -1 = u_r: admissible. PROVEN for this datum. Rankine-Hugoniot
for it: f(1) = 1/2 = f(-1), the flux is continuous across the jump and
the weak form is satisfied identically (u is constant in time on each
side, so the phi_t terms contribute nothing; the phi_x boundary terms
cancel exactly through 1/2 - 1/2).

## 7. The viscous profile is a tanh, and its entropy bill is exact

Seek a stationary viscous wave solving 0 = -u u_x + nu u_xx, so
nu u_xx = u u_x. Treat this as (nu u_x - u^2/2)_x = 0 (the chain rule
on u^2/2 = u u_x, named). Integrate: nu u_x = u^2/2 + C. Boundary
conditions u(+-infinity) = -+ 1 settle C = -1/2 (at either end u_x -> 0
and u^2/2 -> 1/2; the constant is the same, signed bookkeeping stated).

nu u_x = (u^2 - 1)/2. Separate and integrate:
du/(u^2 - 1) = dx/(2 nu), and the antiderivative of the left side is
-artanh u (the standard table entry, consistent with the artanh and
tanh entries the course used in case-large-deviations.md section 4),
so u(x) = -tanh(x/(2 nu)) with the sign and constant chosen to respect
the boundary values at both ends. PROVEN by separation; verify by
substitution. Derivatives of the candidate:

u_x = -(1/(2 nu)) sech^2(x/(2 nu)),
u_xx = (1/(2 nu^2)) sech^2(x/(2 nu)) tanh(x/(2 nu))

(the chain rule twice: u = -tanh xi with xi = x/(2 nu) gives
u_x = -(1/(2 nu)) sech^2 xi, and since d sech^2/dxi = -2 sech^2 tanh,
the second derivative gains one more factor 1/(2 nu), in total
+(1/(2 nu^2)) sech^2 xi tanh xi; the sign passes the check below). Substitute into
nu u_xx - u u_x = sech^2 tanh/(2 nu) - (-tanh)(-(1/(2 nu)) sech^2)
= sech^2 tanh/(2 nu) - tanh sech^2/(2 nu) = 0. PROVEN: the tanh is an
exact stationary viscous shock of width proportional to nu, sitting
between u = 1 at -infinity and u = -1 at +infinity. Letting nu -> 0
recovers the Rankine-Hugoniot jump of section 6: the viscous repair
of the shock is a profile, not a patch.

The entropy bill: for the entropy-entropy flux pair (u^2/2, u^3/3)
(the flux of the entropy is integral of eta'(u) f'(u) du, a one-line
chain computation), the viscous production per unit time is
nu integral (u_x)^2 dx (the classical strong-form computation: dotted
terms shown in the next sentence; the derivative of u^2/2 along the
viscous flow equals -u uu_x + nu u u_xx = -(u^3/3)_x + nu (u u_x)_x
- nu (u_x)^2, every equality a product rule, hence the divergence form
plus the negative defect -nu u_x^2). Compute the integral for the
tanh wave exactly:

nu integral (u_x)^2 dx = (1/(4 nu)) integral sech^4(x/(2 nu)) dx
= (1/2) integral sech^4 xi dxi (xi := x/(2 nu), dx = 2 nu dxi),
and the primitive of sech^4 is tanh - tanh^3/3 (check by
differentiation: sech^2 - tanh^2 sech^2 = sech^2(1 - tanh^2)
= sech^4, an identity of hyperbolic functions named per line), so the
integral equals (1/2)[(1 - 1/3) - (-1 + 1/3)] = (1/2)(4/3) = 2/3.

Independently, the inviscid jump's entropy flux difference:
q(u) = u^3/3 gives q(1) - q(-1) = 1/3 + 1/3 = 2/3, since the shock
speed is zero so no eta-speed term appears. The two computations
producing THE SAME 2/3 is the vanishing-viscosity identity: the
production concentrates into the shock, margin-decimal exact, and the
entropy condition of section 6 is the statement that the bill is
paid. PROVEN for this wave, at every positive nu.

Numeric profile fixture (vanishing-viscosity arithmetic): take
nu = 1/50. Wave halfway points: u(0.01) = -tanh(0.01 * 25)
= -tanh(0.25) = -0.2449 (tanh by the (e^{0.5}-1)/(e^{0.5}+1) form,
table arithmetic), u(0.1) = -tanh(2.5) = -0.9866: essentially the full
jump within |x| of order 2 nu = 0.04. As nu shrinks the same function
squeezes toward the jump; the entropy bill stays 2/3 at every nu
(section 7's integral does not depend on nu at all). SUPPORTED
arithmetic, and the nu-independence is PROVEN.

## 8. Where the frontier is

- General hyperbolic theory: entropy-admissible weak solutions for the
  Cauchy problem are unique (Kruzhkov theory, cited). The Lax and
  Oleinik conditions organize admissible discontinuities beyond the
  Burgers flux; cited.
- Viscous profiles exist for general scalar laws but the exact-tanh
  luxury dies; the structure is recovered through the saddle
  connections of the profile ODE, cited, and is the opening move of
  shock-layer analysis.
- Randomly forced Burgers: the shock statistics carry the intermittency
  fingerprints that case-kolmogorov.md section 5 sees in turbulence
  (velocity increments gather sharp fronts); the -5/3 neighborhood is
  visible in the forced equation (cited).
- Kinetic formulations of conservation laws (Lions-Perthame-Tadmor)
  read entropy solutions as the H-theorem's constraint manifold: the
  tie to case-h-theorem.md section 5 is literal, cited.
