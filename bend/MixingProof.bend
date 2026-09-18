import Base
import ./Exact/Rational.bend as Q
import ./Exact/RationalProof.bend as R
import ./Exact/RationalEquality.bend as E
import ./Exact/Reasoning.bend as C
import ./Exact/Order.bend as O
import ./Exact/Square.bend as Sq
import ./Exact/DivisionAlgebra.bend as A
import ./Finite.bend as F
import ./Moments.bend as M
import ./MomentProof.bend as MP
import ./Mixing.bend as X

law first_moment:
  for +xs: X.Observations
  Q.Eq(F.weighted_sum(X.rows(xs)), X.total_deviation(xs))
def first_moment(xs):
  match xs:
    case X.NoObservations{}:
      R.refl(Q.zero())
    case X.Observation{p, u, tail}:
      match u:
        case Q.Positive{un, ud}:
          +u = {Q.Positive{un, ud} : Q.Positive}
          +d = X.deviation(p, u)
          +head = Q.mul(Q.of_positive(u), Q.div_positive(d, u))
          +t = F.weighted_sum(X.rows(tail))
          E.trans(Q.add(head, t), Q.add(d, t), Q.add(d, X.total_deviation(tail)),
            E.add_congr(head, d, t, A.divide_cancel(d, u)),
            C.add_right(t, X.total_deviation(tail), d, first_moment(tail)))

law second_moment:
  for +xs: X.Observations
  Q.Eq(M.squares(X.rows(xs)), X.chi_square(xs))
def second_moment(xs):
  match xs:
    case X.NoObservations{}:
      R.refl(Q.zero())
    case X.Observation{p, u, tail}:
      match u:
        case Q.Positive{un, ud}:
          +u = {Q.Positive{un, ud} : Q.Positive}
          +d = X.deviation(p, u)
          +ratio = Q.div_positive(d, u)
          +head = Q.mul(Q.of_positive(u), Q.mul(ratio, ratio))
          +target = Q.div_positive(Q.mul(d, d), u)
          +t = M.squares(X.rows(tail))
          E.trans(Q.add(head, t), Q.add(target, t), Q.add(target, X.chi_square(tail)),
            E.add_congr(head, target, t, A.square_divide(d, u)),
            C.add_right(t, X.chi_square(tail), target, second_moment(tail)))

# Rational analogue of the open real-valued Lean goal. There are no
# square roots, and u_i > 0 is carried by the Positive datatype.
law chi_tv_transfer_rat:
  for +xs: X.Observations
  Q.Le<Q.mul(X.total_deviation(xs), X.total_deviation(xs)), Q.mul(X.mass(xs), X.chi_square(xs))>
def chi_tv_transfer_rat(xs):
  +rows = X.rows(xs)
  +sum = F.weighted_sum(rows)
  +total = X.total_deviation(xs)
  +mass = F.weights(rows)
  +second = M.squares(rows)
  O.right(Q.mul(total, total), Q.mul(mass, second), Q.mul(mass, X.chi_square(xs)),
    O.left(Q.mul(total, total), Q.mul(sum, sum), Q.mul(mass, second),
      E.sym(Q.mul(sum, sum), Q.mul(total, total), Sq.congr(sum, total, first_moment(xs))), MP.cauchy_schwarz(rows)),
    C.mul_right(second, X.chi_square(xs), mass, second_moment(xs)))
