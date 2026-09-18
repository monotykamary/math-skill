import Base
import ./Exact/Binary.bend as B
import ./Exact/Rational.bend as Q
import ./Exact/RationalProof.bend as R
import ./Exact/RationalEquality.bend as E
import ./Exact/Reasoning.bend as C
import ./Exact/Decision.bend as D
import ./Frontier.bend as F
import ./Finite.bend as Fin
import ./FiniteProof.bend as FP
import ./LAWS.bend as Laws
import ./MixingProof.bend as MixingProof
import ./Fixtures.bend as Fixtures

def Laws.heat_closed(n, s, rho):
  match n:
    case 0n:
      E.sym(Q.mul(s, Q.sub(Q.one(), Q.one())), Q.zero(),
        E.trans(Q.mul(s, Q.sub(Q.one(), Q.one())), Q.mul(s, Q.zero()), Q.zero(),
          C.mul_right(Q.sub(Q.one(), Q.one()), Q.zero(), s, R.add_neg(Q.one())), R.mul_zero(s)))
    case 1n+p:
      +h = F.heat(p, s, rho)
      +c = F.closed(p, s, rho)
      +input = Q.mul(Q.sub(Q.one(), rho), s)
      E.trans(Q.add(input, Q.mul(rho, h)), Q.add(input, Q.mul(rho, c)), F.closed(1n+p, s, rho),
        C.add_right(Q.mul(rho, h), Q.mul(rho, c), input,
          C.mul_right(h, c, rho, Laws.heat_closed(p, s, rho))),
        R.heat_step_algebra(s, rho, Q.pow(p, rho)))

def Laws.geom_sum(n, rho):
  match n:
    case 0n:
      E.trans(Q.mul(Q.sub(Q.one(), rho), Q.zero()), Q.zero(), Q.sub(Q.one(), Q.one()),
        R.mul_zero(Q.sub(Q.one(), rho)), E.sym(Q.sub(Q.one(), Q.one()), Q.zero(), R.add_neg(Q.one())))
    case 1n+p:
      +a = Q.sub(Q.one(), rho)
      +g = F.geom(p, rho)
      +q = Q.pow(p, rho)
      E.trans(Q.mul(a, Q.add(g, q)), Q.add(Q.mul(a, g), Q.mul(a, q)), Q.sub(Q.one(), Q.mul(rho, q)),
        R.mul_add(a, g, q),
        E.trans(Q.add(Q.mul(a, g), Q.mul(a, q)), Q.add(Q.sub(Q.one(), q), Q.mul(a, q)), Q.sub(Q.one(), Q.mul(rho, q)),
          E.add_congr(Q.mul(a, g), Q.sub(Q.one(), q), Q.mul(a, q), Laws.geom_sum(p, rho)),
          R.geom_step_algebra(rho, q)))

def Laws.heat_step_increment(n, s, rho):
  E.trans(Q.sub(F.heat(1n+n, s, rho), F.heat(n, s, rho)), Q.sub(F.closed(1n+n, s, rho), F.closed(n, s, rho)),
    Q.mul(Q.mul(s, Q.sub(Q.one(), rho)), Q.pow(n, rho)),
    C.sub_congr(F.heat(1n+n, s, rho), F.closed(1n+n, s, rho), F.heat(n, s, rho), F.closed(n, s, rho),
      Laws.heat_closed(1n+n, s, rho), Laws.heat_closed(n, s, rho)),
    R.heat_increment_algebra(s, rho, Q.pow(n, rho)))

def Laws.cool_contracts_deficit(s, rho, w):
  R.cool_contracts_deficit(rho, w, s)

def Laws.cheb_two_of_recurrence(x):
  R.chebyshev_two(x)

law half_power:
  for +n: Nat
  {Q.pow(n, F.half()) == Q.of_positive(F.half_gap(n)) : Q.Number}
def half_power(n):
  match n:
    case 0n:
      {==}
    case 1n+p:
      Equal.cong(Q.Number, Q.Number, x => Q.mul(F.half(), x), Q.pow(p, F.half()), Q.of_positive(F.half_gap(p)), half_power(p))

law heat_gap:
  for +n: Nat
  Q.Eq(Q.add(F.heat(n, Q.one(), F.half()), Q.of_positive(F.half_gap(n))), Q.one())
def heat_gap(n):
  %half_power(n) : Q.Eq(Q.add(F.heat(n, Q.one(), F.half()), _), Q.one())
  +h = F.heat(n, Q.one(), F.half())
  +q = Q.pow(n, F.half())
  +d = Q.sub(Q.one(), q)
  E.trans(Q.add(h, q), Q.add(d, q), Q.one(),
    E.add_congr(h, d, q,
      E.trans(h, Q.mul(Q.one(), d), d, Laws.heat_closed(n, Q.one(), F.half()), C.one_mul(d))),
    R.sub_add(Q.one(), q))

def Laws.heat_capped_lane_below_one(n):
  Q.StrictBound{F.half_gap(n), heat_gap(n)}

def Laws.convex_avg_le_max(xs, m, hmax, hsum):
  FP.convex_avg_le_max(xs, m, hmax, hsum)

def Laws.markov_finset(xs, a, h):
  FP.markov_finset(xs, a, h)

def Laws.heat_fixture_four():
  E.trans(F.heat(4n, Q.one(), F.half()), F.closed(4n, Q.one(), F.half()), Fixtures.fifteen_sixteenths(),
    Laws.heat_closed(4n, Q.one(), F.half()), D.eq(F.closed(4n, Q.one(), F.half()), Fixtures.fifteen_sixteenths(), {==}))

def Laws.heat_crossing_fixture():
  (Q.StrictBound{Fixtures.crossing_gap_before(),
    D.eq(Q.add(F.heat(1n, Fixtures.three_halves(), F.half()), Q.of_positive(Fixtures.crossing_gap_before())), Fixtures.nine_tenths(), {==})},
   Q.Bound{Fixtures.crossing_gap_after(),
    E.trans(Q.add(Fixtures.nine_tenths(), Q.of_nonnegative(Fixtures.crossing_gap_after())), Fixtures.nine_eighths(), F.heat(2n, Fixtures.three_halves(), F.half()),
      D.eq(Q.add(Fixtures.nine_tenths(), Q.of_nonnegative(Fixtures.crossing_gap_after())), Fixtures.nine_eighths(), {==}),
      D.eq(Fixtures.nine_eighths(), F.heat(2n, Fixtures.three_halves(), F.half()), {==}))})


def Laws.chi_tv_transfer_rat(xs):
  MixingProof.chi_tv_transfer_rat(xs)
