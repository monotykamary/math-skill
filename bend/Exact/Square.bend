import Base
import ./Rational.bend as Q
import ./RationalProof.bend as R
import ./RationalEquality.bend as E
import ./Reasoning.bend as C
import ./Order.bend as O
import ./OrderAlgebra.bend as A
import ./Magnitude.bend as M

law congr:
  for +a: Q.Number
  for +b: Q.Number
  for +e: Q.Eq(a, b)
  Q.Eq(Q.mul(a, a), Q.mul(b, b))
def congr(a, b, e):
  E.trans(Q.mul(a, a), Q.mul(b, a), Q.mul(b, b), E.mul_congr(a, b, a, e), C.mul_right(a, b, b, e))

law from_magnitude:
  for +a: Q.Number
  for +m: Q.Nonnegative
  for e: Q.Eq(Q.mul(a, a), Q.mul(Q.of_nonnegative(m), Q.of_nonnegative(m)))
  Q.Le<Q.zero(), Q.mul(a, a)>
def from_magnitude(a, m, e):
  +qm = Q.of_nonnegative(m)
  +product = Q.of_nonnegative(Q.nonnegative_mul(m, m))
  O.right(Q.zero(), product, Q.mul(a, a), O.nonnegative(Q.nonnegative_mul(m, m)),
    E.trans(product, Q.mul(qm, qm), Q.mul(a, a), E.sym(Q.mul(qm, qm), product, A.mul_embedding(m, m)),
      E.sym(Q.mul(a, a), Q.mul(qm, qm), e)))

def cases(+a: Q.Number, result: M.SignedMagnitude<a>) -> Q.Le<Q.zero(), Q.mul(a, a)>:
  match result:
    case M.PositiveCase{+m, e}:
      from_magnitude(a, m, congr(a, Q.of_nonnegative(m), e(Unit{})))
    case M.NegativeCase{+m, e}:
      +qm = Q.of_nonnegative(m)
      from_magnitude(a, m,
        E.trans(Q.mul(a, a), Q.mul(Q.neg(qm), Q.neg(qm)), Q.mul(qm, qm), congr(a, Q.neg(qm), e(Unit{})), R.neg_square(qm)))

law nonnegative:
  for +a: Q.Number
  Q.Le<Q.zero(), Q.mul(a, a)>
def nonnegative(a):
  cases(a, M.decompose(a))
