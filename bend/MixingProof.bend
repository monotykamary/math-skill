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

law root_first_moment:
  for +xs: X.Rooted
  Q.Eq(F.weighted_sum(X.squared_rows(xs)), X.total_deviation(X.unrooted(xs)))
def root_first_moment(xs):
  match xs:
    case X.NoRooted{}:
      R.refl(Q.zero())
    case X.RootedObservation{p, u, s, tail}:
      match s:
        case Q.Positive{sn, sd}:
          +w = Q.positive_mul({Q.Positive{sn, sd} : Q.Positive}, Q.Positive{sn, sd})
          +d = X.deviation(p, u)
          +head = Q.mul(Q.of_positive(w), Q.div_positive(d, w))
          +t = F.weighted_sum(X.squared_rows(tail))
          E.trans(Q.add(head, t), Q.add(d, t), Q.add(d, X.total_deviation(X.unrooted(tail))),
            E.add_congr(head, d, t, A.divide_cancel(d, w)),
            C.add_right(t, X.total_deviation(X.unrooted(tail)), d, root_first_moment(tail)))

law root_second_moment:
  for +xs: X.Rooted
  Q.Eq(M.squares(X.squared_rows(xs)), X.root_chi_square(xs))
def root_second_moment(xs):
  match xs:
    case X.NoRooted{}:
      R.refl(Q.zero())
    case X.RootedObservation{p, u, s, tail}:
      match s:
        case Q.Positive{sn, sd}:
          +s = {Q.Positive{sn, sd} : Q.Positive}
          +w = Q.positive_mul(s, s)
          +d = X.deviation(p, u)
          +ratio = Q.div_positive(d, w)
          +head = Q.mul(Q.of_positive(w), Q.mul(ratio, ratio))
          +r = Q.div_positive(d, s)
          +target = Q.mul(r, r)
          +t = M.squares(X.squared_rows(tail))
          E.trans(Q.add(head, t), Q.add(target, t), Q.add(target, X.root_chi_square(tail)),
            E.add_congr(head, target, t,
              E.trans(head, Q.div_positive(Q.mul(d, d), w), target, A.square_divide(d, w), A.root_square_divide(d, s))),
            C.add_right(t, X.root_chi_square(tail), target, root_second_moment(tail)))

law root_mass:
  for +xs: X.Rooted
  for h: X.Roots(xs)
  Q.Eq(F.weights(X.squared_rows(xs)), X.mass(X.unrooted(xs)))
def root_mass(xs, h):
  match xs:
    case X.NoRooted{}:
      R.refl(Q.zero())
    case X.RootedObservation{p, Q.Positive{un, ud}, Q.Positive{sn, sd}, tail}:
      (square, rest) = h
      +qs = Q.of_positive({Q.Positive{sn, sd} : Q.Positive})
      +qu = Q.of_positive({Q.Positive{un, ud} : Q.Positive})
      +t = F.weights(X.squared_rows(tail))
      E.trans(Q.add(Q.mul(qs, qs), t), Q.add(qu, t), Q.add(qu, X.mass(X.unrooted(tail))),
        E.add_congr(Q.mul(qs, qs), qu, t, square),
        C.add_right(t, X.mass(X.unrooted(tail)), qu, root_mass(tail, rest)))

# Lean's statement with explicit square roots s_i of u_i.
law chi_tv_transfer_sqrt:
  for +xs: X.Rooted
  for h: X.Roots(xs)
  Q.Le<Q.mul(X.total_deviation(X.unrooted(xs)), X.total_deviation(X.unrooted(xs))), Q.mul(X.mass(X.unrooted(xs)), X.root_chi_square(xs))>
def chi_tv_transfer_sqrt(xs, h):
  +rows = X.squared_rows(xs)
  +sum = F.weighted_sum(rows)
  +total = X.total_deviation(X.unrooted(xs))
  +weights = F.weights(rows)
  +mass = X.mass(X.unrooted(xs))
  +second = M.squares(rows)
  +chi = X.root_chi_square(xs)
  O.right(Q.mul(total, total), Q.mul(weights, second), Q.mul(mass, chi),
    O.left(Q.mul(total, total), Q.mul(sum, sum), Q.mul(weights, second),
      E.sym(Q.mul(sum, sum), Q.mul(total, total), Sq.congr(sum, total, root_first_moment(xs))), MP.cauchy_schwarz(rows)),
    E.trans(Q.mul(weights, second), Q.mul(mass, second), Q.mul(mass, chi),
      E.mul_congr(weights, mass, second, root_mass(xs, h)),
      C.mul_right(second, chi, mass, root_second_moment(xs))))
