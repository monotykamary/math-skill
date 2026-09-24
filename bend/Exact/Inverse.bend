import Base
import ./Binary.bend as B
import ./Rational.bend as Q
import ./RationalEquality.bend as E
import ./Magnitude.bend as M
import ./DivisionAlgebra.bend as D

# Total inverse by the sign of the verified magnitude decomposition. As in
# Lean's field division, the inverse of zero is zero; every law that
# cancels takes a Q.Ne(a, Q.zero()) hypothesis.
def inverse_from(-a: Q.Number, r: M.SignedMagnitude<a>) -> Q.Number:
  match r:
    case M.PositiveCase{Q.Nonnegative{B.Zero{}, d}, e}:
      Q.zero()
    case M.PositiveCase{Q.Nonnegative{B.Pos{k}, d}, e}:
      Q.div_positive(Q.one(), Q.Positive{k, d})
    case M.NegativeCase{Q.Nonnegative{B.Zero{}, d}, e}:
      Q.zero()
    case M.NegativeCase{Q.Nonnegative{B.Pos{k}, d}, e}:
      Q.neg(Q.div_positive(Q.one(), Q.Positive{k, d}))

def inv(+a: Q.Number) -> Q.Number:
  inverse_from(a, M.decompose(a))

def div(a: Q.Number, +b: Q.Number) -> Q.Number:
  Q.mul(a, inv(b))

law cancel_from:
  for +a: Q.Number
  for h: Q.Ne(a, Q.zero())
  for r: M.SignedMagnitude<a>
  Q.Eq(Q.mul(a, inverse_from(a, r)), Q.one())
def cancel_from(a, h, r):
  match r:
    case M.PositiveCase{Q.Nonnegative{B.Zero{}, +d}, e}:
      Empty.absurd(Q.Eq(Q.mul(a, Q.zero()), Q.one()),
        h(E.trans(a, Q.Fraction{B.Zero{}, B.Zero{}, d}, Q.zero(), e, Q.Witness{{==}})))
    case M.PositiveCase{Q.Nonnegative{B.Pos{+k}, +d}, e}:
      +u = {Q.Positive{k, d} : Q.Positive}
      +i = Q.div_positive(Q.one(), u)
      E.trans(Q.mul(a, i), Q.mul(Q.of_positive(u), i), Q.one(),
        E.mul_congr(a, Q.of_positive(u), i, e), D.divide_cancel(Q.one(), u))
    case M.NegativeCase{Q.Nonnegative{B.Zero{}, +d}, e}:
      Empty.absurd(Q.Eq(Q.mul(a, Q.zero()), Q.one()),
        h(E.trans(a, Q.Fraction{B.Zero{}, B.Zero{}, d}, Q.zero(), e, Q.Witness{{==}})))
    case M.NegativeCase{Q.Nonnegative{B.Pos{+k}, +d}, e}:
      +u = {Q.Positive{k, d} : Q.Positive}
      +i = Q.neg(Q.div_positive(Q.one(), u))
      # (-x) * (-(1/x)) and x * (1/x) compute to one fraction: the signs
      # swap both binary parts, and the cross products agree.
      E.trans(Q.mul(a, i), Q.mul(Q.neg(Q.of_positive(u)), i), Q.one(),
        E.mul_congr(a, Q.neg(Q.of_positive(u)), i, e), D.divide_cancel(Q.one(), u))

law mul_inv_cancel:
  for +a: Q.Number
  for h: Q.Ne(a, Q.zero())
  Q.Eq(Q.mul(a, inv(a)), Q.one())
def mul_inv_cancel(a, h):
  cancel_from(a, h, M.decompose(a))
