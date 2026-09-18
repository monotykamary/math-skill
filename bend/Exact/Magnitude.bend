import Base
import ./Natural.bend as N
import ./Binary.bend as B
import ./Rational.bend as Q
import ./Difference.bend as D

type SignedMagnitude<-a: Q.Number> is Data:
  PositiveCase{magnitude: Q.Nonnegative, evidence: Q.Eq(a, Q.of_nonnegative(magnitude))}
  NegativeCase{magnitude: Q.Nonnegative, evidence: Q.Eq(a, Q.neg(Q.of_nonnegative(magnitude)))}

law positive_case:
  for +p: B.Whole
  for +n: B.Whole
  for +d: B.Positive
  for +g: N.Number
  for e: {B.value(p) == N.add(B.value(n), g) : N.Number}
  Q.Eq(Q.Fraction{p, n, d}, Q.Fraction{D.from_number(g), B.Zero{}, d})
def positive_case(p, n, d, g, e):
  Q.Witness{(
    %Equal.sym(N.Number, B.value(D.from_number(g)), g, D.from_number_correct(g)) : {N.add(N.mul(B.value(p), B.positive_value(d)), N.Z{}) == N.add(N.mul(_, B.positive_value(d)), N.mul(B.value(n), B.positive_value(d))) : N.Number}
    +pv = B.value(p)
    +nv = B.value(n)
    +dv = B.positive_value(d)
    Equal.trans(N.Number, N.add(N.mul(pv, dv), N.Z{}), N.mul(pv, dv), N.add(N.mul(g, dv), N.mul(nv, dv)), N.add_zero(N.mul(pv, dv)),
      Equal.trans(N.Number, N.mul(pv, dv), N.mul(N.add(nv, g), dv), N.add(N.mul(g, dv), N.mul(nv, dv)),
        Equal.cong(N.Number, N.Number, x => N.mul(x, dv), pv, N.add(nv, g), e),
        Equal.trans(N.Number, N.mul(N.add(nv, g), dv), N.add(N.mul(nv, dv), N.mul(g, dv)), N.add(N.mul(g, dv), N.mul(nv, dv)),
          N.mul_add(nv, g, dv), N.add_comm(N.mul(nv, dv), N.mul(g, dv)))))
  )}

law negative_case:
  for +p: B.Whole
  for +n: B.Whole
  for +d: B.Positive
  for +g: N.Number
  for e: {B.value(n) == N.add(B.value(p), g) : N.Number}
  Q.Eq(Q.Fraction{p, n, d}, Q.Fraction{B.Zero{}, D.from_number(g), d})
def negative_case(p, n, d, g, e):
  Q.Witness{(
    %Equal.sym(N.Number, B.value(D.from_number(g)), g, D.from_number_correct(g)) : {N.add(N.mul(B.value(p), B.positive_value(d)), N.mul(_, B.positive_value(d))) == N.mul(B.value(n), B.positive_value(d)) : N.Number}
    +pv = B.value(p)
    +nv = B.value(n)
    +dv = B.positive_value(d)
    Equal.trans(N.Number, N.add(N.mul(pv, dv), N.mul(g, dv)), N.mul(N.add(pv, g), dv), N.mul(nv, dv),
      Equal.sym(N.Number, N.mul(N.add(pv, g), dv), N.add(N.mul(pv, dv), N.mul(g, dv)), N.mul_add(pv, g, dv)),
      Equal.cong(N.Number, N.Number, x => N.mul(x, dv), N.add(pv, g), nv, Equal.sym(N.Number, nv, N.add(pv, g), e)))
  )}

def from_difference(+p: B.Whole, +n: B.Whole, +d: B.Positive, result: D.Difference<B.value(p), B.value(n)>) -> SignedMagnitude<Q.Fraction{p, n, d}>:
  match result:
    case D.Above{+g, e}:
      PositiveCase{Q.Nonnegative{D.from_number(g), d}, positive_case(p, n, d, g, e)}
    case D.Below{+g, e}:
      NegativeCase{Q.Nonnegative{D.from_number(g), d}, negative_case(p, n, d, g, e)}

def decompose(+a: Q.Number) -> SignedMagnitude<a>:
  match a:
    case Q.Fraction{p, n, d}:
      from_difference(p, n, d, D.difference(B.value(p), B.value(n)))

def forget(-a: Q.Number, result: SignedMagnitude<a>) -> Q.Nonnegative:
  match result:
    case PositiveCase{m, e}:
      m
    case NegativeCase{m, e}:
      m

def magnitude(+a: Q.Number) -> Q.Nonnegative:
  forget(a, decompose(a))
