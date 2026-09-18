import Base
import ./Exact/Rational.bend as Q
import ./Exact/RationalProof.bend as R
import ./Exact/RationalEquality.bend as E
import ./Exact/Reasoning.bend as C
import ./Exact/Order.bend as O
import ./Exact/Square.bend as Sq
import ./Exact/MomentAlgebra.bend as A
import ./Finite.bend as F
import ./Moments.bend as M

law center_identity:
  for +xs: F.Rows
  for +x: Q.Number
  Q.Eq(M.centered(x, xs), M.center_form(x, F.weights(xs), F.weighted_sum(xs), M.squares(xs)))
def center_identity(xs, x):
  match xs:
    case F.NoRows{}:
      A.center_empty(x)
    case F.Row{w, v, tail}:
      +qw = Q.of_nonnegative(w)
      +u = F.weights(tail)
      +s = F.weighted_sum(tail)
      +t = M.squares(tail)
      +term = Q.mul(qw, Q.mul(Q.sub(v, x), Q.sub(v, x)))
      E.trans(Q.add(term, M.centered(x, tail)), Q.add(term, M.center_form(x, u, s, t)),
        M.center_form(x, Q.add(qw, u), Q.add(Q.mul(qw, v), s), Q.add(Q.mul(qw, Q.mul(v, v)), t)),
        C.add_right(M.centered(x, tail), M.center_form(x, u, s, t), term, center_identity(tail, x)),
        A.center_step(x, qw, v, u, s, t))

law scale_nonnegative:
  for +w: Q.Nonnegative
  for +a: Q.Number
  for h: Q.Le<Q.zero(), a>
  Q.Le<Q.zero(), Q.mul(Q.of_nonnegative(w), a)>
def scale_nonnegative(w, a, h):
  +qw = Q.of_nonnegative(w)
  O.left(Q.zero(), Q.mul(qw, Q.zero()), Q.mul(qw, a),
    E.sym(Q.mul(qw, Q.zero()), Q.zero(), R.mul_zero(qw)), O.mul_nonnegative(Q.zero(), a, w, h))

law add_nonnegative:
  for +a: Q.Number
  for +b: Q.Number
  for ha: Q.Le<Q.zero(), a>
  for hb: Q.Le<Q.zero(), b>
  Q.Le<Q.zero(), Q.add(a, b)>
def add_nonnegative(a, b, ha, hb):
  O.left(Q.zero(), Q.add(Q.zero(), Q.zero()), Q.add(a, b),
    E.sym(Q.add(Q.zero(), Q.zero()), Q.zero(), O.zero_add(Q.zero())), O.add(Q.zero(), a, Q.zero(), b, ha, hb))

law center_nonnegative:
  for +xs: F.Rows
  for +x: Q.Number
  Q.Le<Q.zero(), M.centered(x, xs)>
def center_nonnegative(xs, x):
  match xs:
    case F.NoRows{}:
      O.refl(Q.zero())
    case F.Row{w, v, tail}:
      +d = Q.sub(v, x)
      add_nonnegative(Q.mul(Q.of_nonnegative(w), Q.mul(d, d)), M.centered(x, tail),
        scale_nonnegative(w, Q.mul(d, d), Sq.nonnegative(d)), center_nonnegative(tail, x))

law defect_step:
  for +w: Q.Nonnegative
  for +v: Q.Number
  for +tail: F.Rows
  Q.Eq(M.defect(F.Row{w, v, tail}), Q.add(M.defect(tail), Q.mul(Q.of_nonnegative(w), M.centered(v, tail))))
def defect_step(w, v, tail):
  +qw = Q.of_nonnegative(w)
  +u = F.weights(tail)
  +s = F.weighted_sum(tail)
  +t = M.squares(tail)
  +d = M.defect(tail)
  +c = M.centered(v, tail)
  +form = M.center_form(v, u, s, t)
  E.trans(M.defect(F.Row{w, v, tail}), Q.add(d, Q.mul(qw, form)), Q.add(d, Q.mul(qw, c)),
    A.lagrange_step(qw, v, u, s, t),
    C.add_right(Q.mul(qw, form), Q.mul(qw, c), d,
      C.mul_right(form, c, qw, E.sym(c, form, center_identity(tail, v)))))

law defect_nonnegative:
  for +xs: F.Rows
  Q.Le<Q.zero(), M.defect(xs)>
def defect_nonnegative(xs):
  match xs:
    case F.NoRows{}:
      O.refl(Q.zero())
    case F.Row{w, v, tail}:
      +d = M.defect(tail)
      +cross = Q.mul(Q.of_nonnegative(w), M.centered(v, tail))
      O.right(Q.zero(), Q.add(d, cross), M.defect(F.Row{w, v, tail}),
        add_nonnegative(d, cross, defect_nonnegative(tail), scale_nonnegative(w, M.centered(v, tail), center_nonnegative(tail, v))),
        E.sym(M.defect(F.Row{w, v, tail}), Q.add(d, cross), defect_step(w, v, tail)))

law cauchy_schwarz:
  for +xs: F.Rows
  Q.Le<Q.mul(F.weighted_sum(xs), F.weighted_sum(xs)), Q.mul(F.weights(xs), M.squares(xs))>
def cauchy_schwarz(xs):
  +s = F.weighted_sum(xs)
  +lhs = Q.mul(s, s)
  +rhs = Q.mul(F.weights(xs), M.squares(xs))
  +d = M.defect(xs)
  O.right(lhs, Q.add(lhs, d), rhs,
    O.left(lhs, Q.add(lhs, Q.zero()), Q.add(lhs, d), E.sym(Q.add(lhs, Q.zero()), lhs, R.add_zero(lhs)),
      O.add_left(Q.zero(), d, lhs, defect_nonnegative(xs))),
    A.add_sub_cancel(lhs, rhs))
