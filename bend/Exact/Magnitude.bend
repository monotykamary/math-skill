import Base
import ./Natural.bend as N
import ./Binary.bend as B
import ./Rational.bend as Q
import ./Subtraction.bend as S

# The sign and magnitude of a rational. The magnitude is computed by binary
# subtraction of the numerator parts; the evidence is a thunk, so running
# code never evaluates the unary proof model and a proof forces it on demand.
type SignedMagnitude<-a: Q.Number> is Type:
  PositiveCase{magnitude: Q.Nonnegative, evidence: Unit -> Q.Eq(a, Q.of_nonnegative(magnitude))}
  NegativeCase{magnitude: Q.Nonnegative, evidence: Unit -> Q.Eq(a, Q.neg(Q.of_nonnegative(magnitude)))}

law positive_case:
  for +p: B.Whole
  for +n: B.Whole
  for +d: B.Positive
  for +g: B.Whole
  for e: {B.value(p) == N.add(B.value(n), B.value(g)) : N.Number}
  Q.Eq(Q.Fraction{p, n, d}, Q.Fraction{g, B.Zero{}, d})
def positive_case(p, n, d, g, e):
  Q.Witness{(
    +pv = B.value(p)
    +nv = B.value(n)
    +gv = B.value(g)
    +dv = B.positive_value(d)
    Equal.trans(N.Number, N.add(N.mul(pv, dv), N.Z{}), N.mul(pv, dv), N.add(N.mul(gv, dv), N.mul(nv, dv)), N.add_zero(N.mul(pv, dv)),
      Equal.trans(N.Number, N.mul(pv, dv), N.mul(N.add(nv, gv), dv), N.add(N.mul(gv, dv), N.mul(nv, dv)),
        Equal.cong(N.Number, N.Number, x => N.mul(x, dv), pv, N.add(nv, gv), e),
        Equal.trans(N.Number, N.mul(N.add(nv, gv), dv), N.add(N.mul(nv, dv), N.mul(gv, dv)), N.add(N.mul(gv, dv), N.mul(nv, dv)),
          N.mul_add(nv, gv, dv), N.add_comm(N.mul(nv, dv), N.mul(gv, dv)))))
  )}

law negative_case:
  for +p: B.Whole
  for +n: B.Whole
  for +d: B.Positive
  for +g: B.Whole
  for e: {B.value(n) == N.add(B.value(p), B.value(g)) : N.Number}
  Q.Eq(Q.Fraction{p, n, d}, Q.Fraction{B.Zero{}, g, d})
def negative_case(p, n, d, g, e):
  Q.Witness{(
    +pv = B.value(p)
    +nv = B.value(n)
    +gv = B.value(g)
    +dv = B.positive_value(d)
    Equal.trans(N.Number, N.add(N.mul(pv, dv), N.mul(gv, dv)), N.mul(N.add(pv, gv), dv), N.mul(nv, dv),
      Equal.sym(N.Number, N.mul(N.add(pv, gv), dv), N.add(N.mul(pv, dv), N.mul(gv, dv)), N.mul_add(pv, gv, dv)),
      Equal.cong(N.Number, N.Number, x => N.mul(x, dv), N.add(pv, gv), nv, Equal.sym(N.Number, nv, N.add(pv, gv), e)))
  )}

def from_gap(+p: B.Whole, +n: B.Whole, +d: B.Positive, r: S.Gap, h: Unit -> S.Holds(B.value(p), B.value(n), r)) -> SignedMagnitude<Q.Fraction{p, n, d}>:
  match r:
    case S.Same{}:
      PositiveCase{Q.Nonnegative{B.Zero{}, d}, u => positive_case(p, n, d, B.Zero{},
        Equal.trans(N.Number, B.value(p), B.value(n), N.add(B.value(n), N.Z{}), h(Unit{}),
          Equal.sym(N.Number, N.add(B.value(n), N.Z{}), B.value(n), N.add_zero(B.value(n)))))}
    case S.Above{+g}:
      PositiveCase{Q.Nonnegative{B.Pos{g}, d}, u => positive_case(p, n, d, B.Pos{g}, h(Unit{}))}
    case S.Below{+g}:
      NegativeCase{Q.Nonnegative{B.Pos{g}, d}, u => negative_case(p, n, d, B.Pos{g}, h(Unit{}))}

def decompose(+a: Q.Number) -> SignedMagnitude<a>:
  match a:
    case Q.Fraction{p, n, d}:
      from_gap(p, n, d, S.compare(p, n), u => S.compare_correct(p, n))

def forget(-a: Q.Number, result: SignedMagnitude<a>) -> Q.Nonnegative:
  match result:
    case PositiveCase{m, e}:
      m
    case NegativeCase{m, e}:
      m

def magnitude(+a: Q.Number) -> Q.Nonnegative:
  forget(a, decompose(a))
