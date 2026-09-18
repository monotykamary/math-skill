import Base
import ./Exact/Rational.bend as Q
import ./Exact/RationalProof.bend as R
import ./Exact/RationalEquality.bend as E
import ./Exact/Reasoning.bend as C
import ./Exact/Order.bend as O
import ./Exact/OrderAlgebra.bend as A
import ./Finite.bend as F

law weighted_bound:
  for +xs: F.Rows
  for +m: Q.Number
  for h: F.AllBelow(m, xs)
  Q.Le<F.weighted_sum(xs), Q.mul(F.weights(xs), m)>
def weighted_bound(xs, m, h):
  match xs:
    case F.NoRows{}:
      O.right(Q.zero(), Q.zero(), Q.mul(Q.zero(), m), O.refl(Q.zero()),
        E.sym(Q.mul(Q.zero(), m), Q.zero(), O.zero_mul(m)))
    case F.Row{w, v, tail}:
      (bound, rest) = h
      +qw = Q.of_nonnegative(w)
      +tw = F.weights(tail)
      +ts = F.weighted_sum(tail)
      O.right(Q.add(Q.mul(qw, v), ts), Q.add(Q.mul(qw, m), Q.mul(tw, m)), Q.mul(Q.add(qw, tw), m),
        O.add(Q.mul(qw, v), Q.mul(qw, m), ts, Q.mul(tw, m),
          O.mul_nonnegative(v, m, w, bound), weighted_bound(tail, m, rest)),
        E.sym(Q.mul(Q.add(qw, tw), m), Q.add(Q.mul(qw, m), Q.mul(tw, m)), R.weighted_split(qw, tw, m)))

law convex_avg_le_max:
  for +xs: F.Rows
  for +m: Q.Number
  for hmax: F.AllBelow(m, xs)
  for hsum: Q.Eq(F.weights(xs), Q.one())
  Q.Le<F.weighted_sum(xs), m>
def convex_avg_le_max(xs, m, hmax, hsum):
  O.right(F.weighted_sum(xs), Q.mul(F.weights(xs), m), m,
    weighted_bound(xs, m, hmax),
    E.trans(Q.mul(F.weights(xs), m), Q.mul(Q.one(), m), m,
      E.mul_congr(F.weights(xs), Q.one(), m, hsum), C.one_mul(m)))

law product_nonnegative:
  for +w: Q.Nonnegative
  for +x: Q.Nonnegative
  Q.Le<Q.zero(), Q.mul(Q.of_nonnegative(w), Q.of_nonnegative(x))>
def product_nonnegative(w, x):
  O.right(Q.zero(), Q.of_nonnegative(Q.nonnegative_mul(w, x)), Q.mul(Q.of_nonnegative(w), Q.of_nonnegative(x)),
    O.nonnegative(Q.nonnegative_mul(w, x)),
    E.sym(Q.mul(Q.of_nonnegative(w), Q.of_nonnegative(x)), Q.of_nonnegative(Q.nonnegative_mul(w, x)), A.mul_embedding(w, x)))

law markov_finset:
  for +xs: F.Samples
  for +a: Q.Number
  for h: F.Above(a, xs)
  Q.Le<Q.mul(a, F.selected_weight(xs)), F.expectation(xs)>
def markov_finset(xs, a, h):
  match xs:
    case F.NoSamples{}:
      O.left(Q.mul(a, Q.zero()), Q.zero(), Q.zero(), R.mul_zero(a), O.refl(Q.zero()))
    case F.Sample{w, x, chosen, tail}:
      match chosen:
        case False{}:
          +lhs = Q.mul(a, F.selected_weight(tail))
          +rhs = F.expectation(tail)
          +product = Q.mul(Q.of_nonnegative(w), Q.of_nonnegative(x))
          O.left(lhs, Q.add(Q.zero(), lhs), Q.add(product, rhs),
            E.sym(Q.add(Q.zero(), lhs), lhs, O.zero_add(lhs)),
            O.add(Q.zero(), product, lhs, rhs, product_nonnegative(w, x), markov_finset(tail, a, h)))
        case True{}:
          (bound, rest) = h
          +qw = Q.of_nonnegative(w)
          +qx = Q.of_nonnegative(x)
          +tw = F.selected_weight(tail)
          +te = F.expectation(tail)
          O.left(Q.mul(a, Q.add(qw, tw)), Q.add(Q.mul(qw, a), Q.mul(a, tw)), Q.add(Q.mul(qw, qx), te),
            R.markov_split(a, qw, tw),
            O.add(Q.mul(qw, a), Q.mul(qw, qx), Q.mul(a, tw), te,
              O.mul_nonnegative(a, qx, w, bound), markov_finset(tail, a, rest)))
