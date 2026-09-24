import Base
import ./Exact/Rational.bend as Q
import ./Exact/RationalProof.bend as R
import ./Exact/RationalEquality.bend as E
import ./Exact/Reasoning.bend as C
import ./Exact/Order.bend as O
import ./Exact/OrderAlgebra.bend as A
import ./Exact/Compare.bend as K
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

law select_above:
  for +a: Q.Number
  for +w: Q.Nonnegative
  for +x: Q.Nonnegative
  for d: K.Decision<a, Q.of_nonnegative(x)>
  for +s: F.Samples
  for rest: F.Above(a, s)
  F.Above(a, F.Sample{w, x, F.reaches(a, Q.of_nonnegative(x), d), s})
def select_above(a, w, x, d, s, rest):
  match d:
    case K.AtMost{h}:
      (h(Unit{}), rest)
    case K.Exceeds{g}:
      rest

law select_below:
  for +a: Q.Number
  for +w: Q.Nonnegative
  for +x: Q.Nonnegative
  for d: K.Decision<a, Q.of_nonnegative(x)>
  for +s: F.Samples
  for rest: F.Below(a, s)
  F.Below(a, F.Sample{w, x, F.reaches(a, Q.of_nonnegative(x), d), s})
def select_below(a, w, x, d, s, rest):
  match d:
    case K.AtMost{h}:
      rest
    case K.Exceeds{g}:
      (g(Unit{}), rest)

law threshold_above:
  for +a: Q.Number
  for +xs: F.Draws
  F.Above(a, F.threshold(a, xs))
def threshold_above(a, xs):
  match xs:
    case F.NoDraws{}:
      Unit{}
    case F.Draw{w, x, tail}:
      select_above(a, w, x, K.decide(a, Q.of_nonnegative(x)), F.threshold(a, tail), threshold_above(a, tail))

law threshold_below:
  for +a: Q.Number
  for +xs: F.Draws
  F.Below(a, F.threshold(a, xs))
def threshold_below(a, xs):
  match xs:
    case F.NoDraws{}:
      Unit{}
    case F.Draw{w, x, tail}:
      select_below(a, w, x, K.decide(a, Q.of_nonnegative(x)), F.threshold(a, tail), threshold_below(a, tail))

# Every selected draw reaches a; every other one falls strictly short.
law threshold_exact:
  for +a: Q.Number
  for +xs: F.Draws
  F.Above(a, F.threshold(a, xs)) & F.Below(a, F.threshold(a, xs))
def threshold_exact(a, xs):
  (threshold_above(a, xs), threshold_below(a, xs))

law mean_threshold:
  for +a: Q.Number
  for +xs: F.Draws
  {F.expectation(F.threshold(a, xs)) == F.mean(xs) : Q.Number}
def mean_threshold(a, xs):
  match xs:
    case F.NoDraws{}:
      {==}
    case F.Draw{w, x, tail}:
      +head = Q.mul(Q.of_nonnegative(w), Q.of_nonnegative(x))
      %mean_threshold(a, tail) : {Q.add(head, F.expectation(F.threshold(a, tail))) == Q.add(head, _) : Q.Number}
      {==}

law markov_threshold:
  for +xs: F.Draws
  for +a: Q.Number
  Q.Le<Q.mul(a, F.selected_weight(F.threshold(a, xs))), F.mean(xs)>
def markov_threshold(xs, a):
  %mean_threshold(a, xs) : Q.Le<Q.mul(a, F.selected_weight(F.threshold(a, xs))), _>
  markov_finset(F.threshold(a, xs), a, threshold_above(a, xs))

law maximum_start:
  for +xs: F.Rows
  for +m: Q.Number
  Q.Le<m, F.maximum(xs, m)>
def maximum_start(xs, m):
  match xs:
    case F.NoRows{}:
      O.refl(m)
    case F.Row{w, v, tail}:
      +top = K.max(m, v)
      O.trans(m, top, F.maximum(tail, top), K.max_left(m, v), maximum_start(tail, top))

law maximum_bounds:
  for +xs: F.Rows
  for +m: Q.Number
  F.AllBelow(F.maximum(xs, m), xs)
def maximum_bounds(xs, m):
  match xs:
    case F.NoRows{}:
      Unit{}
    case F.Row{w, v, tail}:
      +top = K.max(m, v)
      (O.trans(v, top, F.maximum(tail, top), K.max_right(m, v), maximum_start(tail, top)), maximum_bounds(tail, top))

law attained_step:
  for +found: Q.Number
  for +top: Q.Number
  for +m: Q.Number
  for +v: Q.Number
  for +tail: F.Rows
  for seen: Or({found == top : Q.Number}, F.Member(found, tail))
  for choice: Or({top == m : Q.Number}, {top == v : Q.Number})
  Or({found == m : Q.Number}, Or({found == v : Q.Number}, F.Member(found, tail)))
def attained_step(found, top, m, v, tail, seen, choice):
  match seen:
    case Inr{member}:
      Inr{Inr{member}}
    case Inl{e}:
      match choice:
        case Inl{f}:
          Inl{Equal.trans(Q.Number, found, top, m, e, f)}
        case Inr{f}:
          Inr{Inl{Equal.trans(Q.Number, found, top, v, e, f)}}

# The maximum is the seed or one of the listed values.
law maximum_attained:
  for +xs: F.Rows
  for +m: Q.Number
  Or({F.maximum(xs, m) == m : Q.Number}, F.Member(F.maximum(xs, m), xs))
def maximum_attained(xs, m):
  match xs:
    case F.NoRows{}:
      Inl{{==}}
    case F.Row{w, v, tail}:
      +top = K.max(m, v)
      attained_step(F.maximum(tail, top), top, m, v, tail, maximum_attained(tail, top), K.max_choice(m, v))

law convex_avg_le_maximum:
  for +w: Q.Nonnegative
  for +v: Q.Number
  for +tail: F.Rows
  for hsum: Q.Eq(F.weights(F.Row{w, v, tail}), Q.one())
  Q.Le<F.weighted_sum(F.Row{w, v, tail}), F.maximum(tail, v)>
def convex_avg_le_maximum(w, v, tail, hsum):
  convex_avg_le_max(F.Row{w, v, tail}, F.maximum(tail, v), (maximum_start(tail, v), maximum_bounds(tail, v)), hsum)

# Seeded by the first row, the maximum is one of the row values.
law maximum_member:
  for +w: Q.Nonnegative
  for +v: Q.Number
  for +tail: F.Rows
  F.Member(F.maximum(tail, v), F.Row{w, v, tail})
def maximum_member(w, v, tail):
  maximum_attained(tail, v)
