import Base
import ./Natural.bend as N
import ./Binary.bend as B
import ./BinaryProof.bend as BP

# Constructive comparison of the inductive semantic model. It is
# structurally total but linear in numeric magnitude. Magnitude.bend uses
# this reference implementation; large runtime arithmetic should stay binary.
type Difference<-a: N.Number, -b: N.Number> is Data:
  Above{gap: N.Number, evidence: {a == N.add(b, gap) : N.Number}}
  Below{gap: N.Number, evidence: {b == N.add(a, gap) : N.Number}}

def lift(-a: N.Number, -b: N.Number, d: Difference<a, b>) -> Difference<N.S{a}, N.S{b}>:
  match d:
    case Above{g, e}:
      Above{g, Equal.cong(N.Number, N.Number, x => N.S{x}, a, N.add(b, g), e)}
    case Below{g, e}:
      Below{g, Equal.cong(N.Number, N.Number, x => N.S{x}, b, N.add(a, g), e)}

def difference(+a: N.Number, +b: N.Number) -> Difference<a, b>:
  match a b:
    case N.Z{} b:
      Below{b, {==}}
    case N.S{p} N.Z{}:
      Above{N.S{p}, {==}}
    case N.S{p} N.S{q}:
      lift(p, q, difference(p, q))

def from_number(a: N.Number) -> B.Whole:
  match a:
    case N.Z{}:
      B.Zero{}
    case N.S{p}:
      B.successor(from_number(p))

law successor_correct:
  for +a: B.Whole
  {B.value(B.successor(a)) == N.S{B.value(a)} : N.Number}
def successor_correct(a):
  match a:
    case B.Zero{}:
      {==}
    case B.Pos{p}:
      BP.inc_correct(p)

law from_number_correct:
  for +a: N.Number
  {B.value(from_number(a)) == a : N.Number}
def from_number_correct(a):
  match a:
    case N.Z{}:
      {==}
    case N.S{p}:
      Equal.trans(N.Number, B.value(B.successor(from_number(p))), N.S{B.value(from_number(p))}, N.S{p},
        successor_correct(from_number(p)),
        Equal.cong(N.Number, N.Number, x => N.S{x}, B.value(from_number(p)), p, from_number_correct(p)))
