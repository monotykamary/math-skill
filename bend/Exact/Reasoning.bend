import Base
import ./Natural.bend as N
import ./Binary.bend as B
import ./Rational.bend as Q
import ./RationalProof.bend as R
import ./RationalEquality.bend as E

law add_right:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for e: Q.Eq(a, b)
  Q.Eq(Q.add(c, a), Q.add(c, b))
def add_right(a, b, c, e):
  E.trans(Q.add(c, a), Q.add(a, c), Q.add(c, b), R.add_comm(c, a),
    E.trans(Q.add(a, c), Q.add(b, c), Q.add(c, b), E.add_congr(a, b, c, e), R.add_comm(b, c)))

law mul_right:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for e: Q.Eq(a, b)
  Q.Eq(Q.mul(c, a), Q.mul(c, b))
def mul_right(a, b, c, e):
  E.trans(Q.mul(c, a), Q.mul(a, c), Q.mul(c, b), R.mul_comm(c, a),
    E.trans(Q.mul(a, c), Q.mul(b, c), Q.mul(c, b), E.mul_congr(a, b, c, e), R.mul_comm(b, c)))

law one_mul:
  for +a: Q.Number
  Q.Eq(Q.mul(Q.one(), a), a)
def one_mul(a):
  E.trans(Q.mul(Q.one(), a), Q.mul(a, Q.one()), a, R.mul_comm(Q.one(), a), R.mul_one(a))

law neg_congr:
  for +a: Q.Number
  for +b: Q.Number
  for e: Q.Eq(a, b)
  Q.Eq(Q.neg(a), Q.neg(b))
def neg_congr(a, b, e):
  match a b e:
    case Q.Fraction{ap, an, ad} Q.Fraction{bp, bn, bd} Q.Witness{e}:
      Q.Witness{(
        +x = N.mul(B.value(ap), B.positive_value(bd))
        +y = N.mul(B.value(bn), B.positive_value(ad))
        +z = N.mul(B.value(bp), B.positive_value(ad))
        +w = N.mul(B.value(an), B.positive_value(bd))
        Equal.trans(N.Number, N.add(w, z), N.add(z, w), N.add(y, x), N.add_comm(w, z),
          Equal.trans(N.Number, N.add(z, w), N.add(x, y), N.add(y, x),
            Equal.sym(N.Number, N.add(x, y), N.add(z, w), e), N.add_comm(x, y)))
      )}

law sub_congr:
  for +a: Q.Number
  for +b: Q.Number
  for +c: Q.Number
  for +d: Q.Number
  for e: Q.Eq(a, b)
  for f: Q.Eq(c, d)
  Q.Eq(Q.sub(a, c), Q.sub(b, d))
def sub_congr(a, b, c, d, e, f):
  E.trans(Q.sub(a, c), Q.sub(b, c), Q.sub(b, d), E.add_congr(a, b, Q.neg(c), e),
    add_right(Q.neg(c), Q.neg(d), b, neg_congr(c, d, f)))
