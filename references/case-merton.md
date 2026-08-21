# Case study: the Merton problem, or Kelly in continuous time

Finance case #3. The discrete bettor of case-kelly.md moves to a market
where the risky asset follows geometric Brownian motion, the toolkit of
case-black-scholes.md. One Ito application per section. The answer is the
same one-word engine: log-optimal growth, now with the risk premium over
squared volatility in the role the edge-over-odds played there. Every
square completed out loud.

## 1. The market and the wealth equation

A safe bond grows at constant rate r (the holding of a token compounds by
the exponential; the defining property d(rcash)/dt polished in
case-black-scholes.md section 4). A risky asset has price dynamics
dS/S = mu dt + sigma dB_t from case-black-scholes.md section 3, that is
the exponential S_t = S_0 exp((mu - sigma^2/2)t + sigma B_t), PROVEN there
by Ito. An investor keeps a fraction pi of wealth W in the risky asset and
1 - pi in the bond; take pi constant first (the optimization comes after).
Wealth per turn:

dW = W(1 - pi) r dt + W pi (dS/S)
   = W [r + pi (mu - r)] dt + W pi sigma dB_t.

Each line is bookkeeping: the dollar amounts invested in each position
multiply their returns, and dS/S is substituted from the price dynamics.
PROVEN as an accounting identity; the stochastic differential is taken in
the Ito sense throughout (the convention established in
case-black-scholes.md section 3).

## 2. Log wealth by Ito, both terms

f(w) = ln w has f'(w) = 1/w and f''(w) = -1/w^2 (derivatives of ln, the
standard table entry the course committed in case-kelly.md section 3).
Ito's formula for the scalar process with the quadratic variation of
section 2 of the Black-Scholes case, (dB)^2 = dt:

d ln W = (1/W) dW + (1/2)(-1/W^2) d<W>
       = [r + pi(mu - r)] dt + pi sigma dB_t - (1/2) pi^2 sigma^2 dt

because d<W> = pi^2 sigma^2 W^2 dt, the only nonzero bracket being
(pi W sigma dB)^2 with the rule (dB)^2 = dt (named; the same rule
justified in case-black-scholes.md section 2 through the mean-square
computation). Collect the dt terms:

d ln W = [r + pi(mu - r) - pi^2 sigma^2/2] dt + pi sigma dB_t.

The growth rate per unit time: the expectation of the dB term is zero
(the stochastic integral against Brownian motion is a martingale with
mean zero, the named martingale property cited from the Black-Scholes
case section 3), so

g(pi) := r + pi(mu - r) - (pi^2 sigma^2)/2.

PROVEN. This is the continuous Kelly function: same shape as
case-kelly.md section 3, one log-concave quadratic.

## 3. The optimizer by completing the square

Complete the square, every term on the sheet: write A := mu - r.

pi A - pi^2 sigma^2/2 = -(sigma^2/2)[pi^2 - (2A/sigma^2) pi]
= -(sigma^2/2)[(pi - A/sigma^2)^2 - A^2/sigma^4]
(the bracket identity (x - c)^2 = x^2 - 2cx + c^2 applied forward with
c = A/sigma^2, then subtract c^2), hence

g(pi) = r + A^2/(2 sigma^2) - (sigma^2/2)(pi - A/sigma^2)^2.

The pure-square term is nonpositive and zero exactly at
pi* = A/sigma^2 = (mu - r)/sigma^2. PROVEN: pi* is the unique maximizer
with maximal rate g* = r + (mu - r)^2/(2 sigma^2). The dictionary
against discrete Kelly: there f* = edge/variance with edge pb - q and
per-round variance b^2 pq; here pi* = risk premium/volatility^2, the
same ratio at the level of the local mean and local variance of log
wealth. The claim that the two problems are the same object at
different timescales is the small-time identification below, tagged
SUPPORTED: it rests on the CLT fluctuation scale of the discrete
multiplicative game (case-kelly.md sections 2 and 5), the same scale
that produced Brownian motion in case-black-scholes.md section 1.

## 4. The HJB reading: the value function resolves the control

This is the sturdier engine for the whole course, so carry it in full
for the log case. The generator L(pi) of the controlled wealth process
acts on smooth v by L(pi)v = [r + pi A]w v_w + (1/2) pi^2 sigma^2 w^2
v_ww (each coefficient read off the differential of section 1: the dt
coefficient times v_w, half the diffusion coefficient squared times
v_ww, the Ito chain rule as written in case-black-scholes.md section 4).
The Hamilton-Jacobi-Bellman equation for the value of a terminal
criterion with zero running cost:

0 = sup_pi { v_t + L(pi)v }.

For the log criterion the natural candidate is v(t,w) = ln w +
c (T - t) for a constant c to be determined. Derivatives: v_t = -c,
v_w = 1/w, v_ww = -1/w^2 (each by the chain rule as it comes). Insert:

0 = sup_pi { -c + [r + pi A] - (1/2) pi^2 sigma^2 }
  = -c + sup_pi { r + pi A - pi^2 sigma^2/2 }.

The sup is exactly g(pi) of sections 2 and 3, evaluated there:
sup_pi g(pi) = r + A^2/(2 sigma^2). Hence c = r + (mu - r)^2/(2
sigma^2) = g*: the HJB forces the constant to be the very growth rate
the direct computation found. PROVEN as the consistency of one object
seen twice; the full verification theorem (that a smooth HJB solution
is the value function, with the maximizing control the optimizer) is
cited machinery, and for log utility the Itô-integral direct argument
of section 3 certifies the candidate independently (the course's two
instruments agree).

## 5. Half-Merton keeps three quarters

The concavity arithmetic is identical territory to the half-Kelly
paragraph of case-kelly.md section 5. g(pi*/2) =
r + A^2/(2 sigma^2) - (sigma^2/2)(A/(2 sigma^2))^2
= r + A^2/(2 sigma^2) - A^2/(8 sigma^2) = r + (3/4) A^2/(2 sigma^2):
three quarters of the excess, at half the exposure. Same formula
(2c - c^2) at c = 1/2 as there, now with one extra route available:
it also follows from the square form of section 3 by putting
pi = pi*/2 inside one term. PROVEN.

## 6. Numeric fixture, recomputed

mu = 0.12, r = 0.04, sigma = 0.20 per year. Risk premium
A = 0.08. pi* = 0.08/0.04 = 2.00: two units of exposure per unit of
wealth, a levered position (borrow 1 unit at r to hold 2 at mu).
g* = 0.04 + 0.08^2/(2 * 0.04) = 0.04 + 0.0064/0.08 = 0.04 + 0.08
= 0.12 nats per year: expected log wealth grows linearly at rate g*,
and the doubling time is ln 2 / 0.12 ~ 5.78 years (the expectation
satisfies E[ln W] = ln W_0 + g* t, the same first-order solvability as
case-heat-kernel.md section 2). Half-Merton:
pi = 1.00, g = 0.04 + 0.08 - 0.02 = 0.10: three quarters of the excess
(the excess 0.08 decays to excess 0.06), as section 5 ordered. A
one-hundredth rerun of the arithmetic satisfies the covenant check
service: recompute before trusting.

## 7. Falsifiable checks

- Zero premium: mu = r gives A = 0 and pi* = 0 by the formula; the
  square form then forces g = r with no investment. PROVEN by
  substitution. A stock offering nothing beyond the bond receives none
  of the portfolio: the log-optimal answer to a fair coin.
- No volatility: sigma -> 0 with A > 0 sends pi* -> infinity and
  g* -> infinity (ratios with shrinking denominators, limits stated and
  computed). A riskless premium is an arbitrage in this model, and the
  frictionless portfolio says borrow without bound; the transaction-cost
  frontier below is where this limit dies. PROVEN limits, and the
  honest reason no sane desk runs this.
- The Black-Scholes contrast, in one sentence each: hedging set
  Delta = V_S and REMOVED mu from the price; allocating sets pi* and
  needs mu exactly. Both conclusions are the same Ito computation with
  the opposite instruction, PROVEN in their files; the pairing is the
  lesson.

## 8. Where the frontier is

- Consumption and endowments: Merton's full problem maximizes utility
  of a lifetime consumption stream and the HJB picks a c* consumption
  policy along with pi*; the equation gains one term, the engine above
  is unchanged. Cited, and flagged as the natural next derivation.
- Beyond log: constant relative risk aversion gamma gives the classical
  pi* = A/(sigma^2 gamma): the power-utility HJB is an exercise with
  v = w^(1-gamma)/(1-gamma) and the same completion of squares.
- Transaction costs: the no-trade band of Davis-Norman replaces the
  single pi*; the band width scales like cost^(1/3), a genuinely
  different regime (cited frontier, ties to the Leland repair mentioned
  in case-black-scholes.md section 8).
- Robust control: if the drift mu is not known, the maximization over
  pi turns into a sup-inf game (Hansen-Sargent), the continuous sibling
  of the distributionally robust Kelly of case-kelly.md section 7.
- Rough volatility breaks the bracket computation itself: with H ~ 0.1
  the quadratic variation statement (dB)^2 = dt has a fractional twin
  and the HJB of section 4 needs the rewriting flagged in
  case-black-scholes.md section 8.
