import Base
import ./Binary.bend as B
import ./Rational.bend as Q
import ./RationalProof.bend as R
import ./RationalEquality.bend as E
import ./Reasoning.bend as C
import ./OrderAlgebra.bend as A

def zero() -> Q.Nonnegative:
  Q.Nonnegative{B.Zero{}, B.One{}}

law zero_add:
  for +a: Q.Number
  Q.Eq(Q.add(Q.zero(), a), a)
def zero_add(a):
  E.trans(Q.add(Q.zero(), a), Q.add(a, Q.zero()), a, R.add_comm(Q.zero(), a), R.add_zero(a))

law zero_mul:
  for +a: Q.Number
  Q.Eq(Q.mul(Q.zero(), a), Q.zero())
def zero_mul(a):
  E.trans(Q.mul(Q.zero(), a), Q.mul(a, Q.zero()), Q.zero(), R.mul_comm(Q.zero(), a), R.mul_zero(a))

law refl:
  for +a: Q.Number
  Q.Le<a, a>
def refl(a):
  Q.Bound{zero(), R.add_zero(a)}

law nonnegative:
  for +a: Q.Nonnegative
  Q.Le<Q.zero(), Q.of_nonnegative(a)>
def nonnegative(a):
  Q.Bound{a, zero_add(Q.of_nonnegative(a))}

law left:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for e: Q.Eq(a, b)
  for h: Q.Le<b, c>
  Q.Le<a, c>
def left(a, b, c, e, h):
  match h:
    case Q.Bound{+s, f}:
      Q.Bound{s, E.trans(Q.add(a, Q.of_nonnegative(s)), Q.add(b, Q.of_nonnegative(s)), c,
        E.add_congr(a, b, Q.of_nonnegative(s), e), f)}

law right:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for h: Q.Le<a, b>
  for e: Q.Eq(b, c)
  Q.Le<a, c>
def right(a, b, c, h, e):
  match h:
    case Q.Bound{+s, f}:
      Q.Bound{s, E.trans(Q.add(a, Q.of_nonnegative(s)), b, c, f, e)}

law trans:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for ab: Q.Le<a, b>
  for bc: Q.Le<b, c>
  Q.Le<a, c>
def trans(a, b, c, ab, bc):
  match ab bc:
    case Q.Bound{+s, e} Q.Bound{+t, f}:
      +qs = Q.of_nonnegative(s)
      +qt = Q.of_nonnegative(t)
      Q.Bound{Q.nonnegative_add(s, t),
        E.trans(Q.add(a, Q.of_nonnegative(Q.nonnegative_add(s, t))), Q.add(a, Q.add(qs, qt)), c,
          C.add_right(Q.of_nonnegative(Q.nonnegative_add(s, t)), Q.add(qs, qt), a,
            E.sym(Q.add(qs, qt), Q.of_nonnegative(Q.nonnegative_add(s, t)), A.add_embedding(s, t))),
          E.trans(Q.add(a, Q.add(qs, qt)), Q.add(Q.add(a, qs), qt), c,
            E.sym(Q.add(Q.add(a, qs), qt), Q.add(a, Q.add(qs, qt)), R.add_assoc(a, qs, qt)),
            E.trans(Q.add(Q.add(a, qs), qt), Q.add(b, qt), c, E.add_congr(Q.add(a, qs), b, qt, e), f)))}

law add_fixed:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for h: Q.Le<a, b>
  Q.Le<Q.add(a, c), Q.add(b, c)>
def add_fixed(a, b, c, h):
  match h:
    case Q.Bound{+s, e}:
      +qs = Q.of_nonnegative(s)
      Q.Bound{s, E.trans(Q.add(Q.add(a, c), qs), Q.add(Q.add(a, qs), c), Q.add(b, c),
        R.add_shuffle(a, c, qs), E.add_congr(Q.add(a, qs), b, c, e))}

law add_left:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for h: Q.Le<a, b>
  Q.Le<Q.add(c, a), Q.add(c, b)>
def add_left(a, b, c, h):
  left(Q.add(c, a), Q.add(a, c), Q.add(c, b), R.add_comm(c, a),
    right(Q.add(a, c), Q.add(b, c), Q.add(c, b), add_fixed(a, b, c, h), R.add_comm(b, c)))

law add:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for +d: Q.Number
  for ab: Q.Le<a, b>
  for cd: Q.Le<c, d>
  Q.Le<Q.add(a, c), Q.add(b, d)>
def add(a, b, c, d, ab, cd):
  trans(Q.add(a, c), Q.add(b, c), Q.add(b, d), add_fixed(a, b, c, ab), add_left(c, d, b, cd))

law mul_nonnegative:
  for +a: Q.Number
  for +b: Q.Number
  for +w: Q.Nonnegative
  for h: Q.Le<a, b>
  Q.Le<Q.mul(Q.of_nonnegative(w), a), Q.mul(Q.of_nonnegative(w), b)>
def mul_nonnegative(a, b, w, h):
  match h:
    case Q.Bound{+s, e}:
      +qw = Q.of_nonnegative(w)
      +qs = Q.of_nonnegative(s)
      Q.Bound{Q.nonnegative_mul(w, s),
        E.trans(Q.add(Q.mul(qw, a), Q.of_nonnegative(Q.nonnegative_mul(w, s))), Q.add(Q.mul(qw, a), Q.mul(qw, qs)), Q.mul(qw, b),
          C.add_right(Q.of_nonnegative(Q.nonnegative_mul(w, s)), Q.mul(qw, qs), Q.mul(qw, a),
            E.sym(Q.mul(qw, qs), Q.of_nonnegative(Q.nonnegative_mul(w, s)), A.mul_embedding(w, s))),
          E.trans(Q.add(Q.mul(qw, a), Q.mul(qw, qs)), Q.mul(qw, Q.add(a, qs)), Q.mul(qw, b),
            E.sym(Q.mul(qw, Q.add(a, qs)), Q.add(Q.mul(qw, a), Q.mul(qw, qs)), R.mul_add(qw, a, qs)),
            C.mul_right(Q.add(a, qs), b, qw, e)))}
