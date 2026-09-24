import Base
import ./Exact/Rational.bend as Q
import ./Finite.bend as F

def squares(xs: F.Rows) -> Q.Number:
  match xs:
    case F.NoRows{}:
      Q.zero()
    case F.Row{w, +v, tail}:
      Q.add(Q.mul(Q.of_nonnegative(w), Q.mul(v, v)), squares(tail))

def centered(+x: Q.Number, xs: F.Rows) -> Q.Number:
  match xs:
    case F.NoRows{}:
      Q.zero()
    case F.Row{w, +v, tail}:
      Q.add(Q.mul(Q.of_nonnegative(w), Q.mul(Q.sub(v, x), Q.sub(v, x))), centered(x, tail))

def center_form(+x: Q.Number, u: Q.Number, s: Q.Number, t: Q.Number) -> Q.Number:
  Q.add(Q.sub(t, Q.mul(Q.mul(Q.two(), x), s)), Q.mul(Q.mul(x, x), u))

def defect(+xs: F.Rows) -> Q.Number:
  Q.sub(Q.mul(F.weights(xs), squares(xs)), Q.mul(F.weighted_sum(xs), F.weighted_sum(xs)))
