import Base
import ./Exact/Rational.bend as Q
import ./Frontier.bend as F
import ./Finite.bend as Fin
import ./Mixing.bend as Mixing
import ./Fixtures.bend as Fixtures

# Public claims. No floating-point substitution or parameter restriction.
law heat_closed:
  for +n: Nat
  for +s: Q.Number
  for +rho: Q.Number
  Q.Eq(F.heat(n, s, rho), F.closed(n, s, rho))

law geom_sum:
  for +n: Nat
  for +rho: Q.Number
  Q.Eq(Q.mul(Q.sub(Q.one(), rho), F.geom(n, rho)), Q.sub(Q.one(), Q.pow(n, rho)))

law heat_step_increment:
  for +n: Nat
  for +s: Q.Number
  for +rho: Q.Number
  Q.Eq(Q.sub(F.heat(1n+n, s, rho), F.heat(n, s, rho)), Q.mul(Q.mul(s, Q.sub(Q.one(), rho)), Q.pow(n, rho)))

law cool_contracts_deficit:
  for +s: Q.Number
  for +rho: Q.Number
  for +w: Q.Number
  Q.Eq(Q.sub(F.cool(rho, w), F.cool(rho, s)), Q.mul(rho, Q.sub(w, s)))

law cheb_two_of_recurrence:
  for +x: Q.Number
  Q.Eq(F.chebyshev_two(x), Q.sub(Q.mul(Q.mul(Q.add(Q.one(), Q.one()), x), x), Q.one()))

law heat_capped_lane_below_one:
  for +n: Nat
  Q.Lt<F.heat(n, Q.one(), F.half()), Q.one()>

# Explicit finite-carrier and hypothesis certificates replace Finset's
# implicit instances. The upper-bound formulation also covers a maximum.
law convex_avg_le_max:
  for +xs: Fin.Rows
  for +m: Q.Number
  for hmax: Fin.AllBelow(m, xs)
  for hsum: Q.Eq(Fin.weights(xs), Q.one())
  Q.Le<Fin.weighted_sum(xs), m>

law markov_finset:
  for +xs: Fin.Samples
  for +a: Q.Number
  for h: Fin.Above(a, xs)
  Q.Le<Q.mul(a, Fin.selected_weight(xs)), Fin.expectation(xs)>

law heat_fixture_four:
  Q.Eq(F.heat(4n, Q.one(), F.half()), Fixtures.fifteen_sixteenths())

law heat_crossing_fixture:
  Q.Lt<F.heat(1n, Fixtures.three_halves(), F.half()), Fixtures.nine_tenths()> &
  Q.Le<Fixtures.nine_tenths(), F.heat(2n, Fixtures.three_halves(), F.half())>

# This is a rational-domain theorem. It does not certify the open Lean
# statement over all real numbers or provide a real-analysis library.
law chi_tv_transfer_rat:
  for +xs: Mixing.Observations
  Q.Le<Q.mul(Mixing.total_deviation(xs), Mixing.total_deviation(xs)), Q.mul(Mixing.mass(xs), Mixing.chi_square(xs))>
