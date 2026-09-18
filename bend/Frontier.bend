import Base
import ./Exact/Binary.bend as B
import ./Exact/Rational.bend as Q

# The original EWMA recurrence, for arbitrary signed rational s and rho.
def heat(n: Nat, +s: Q.Number, +rho: Q.Number) -> Q.Number:
  match n:
    case 0n:
      Q.zero()
    case 1n+p:
      Q.add(Q.mul(Q.sub(Q.one(), rho), s), Q.mul(rho, heat(p, s, rho)))

def closed(n: Nat, s: Q.Number, rho: Q.Number) -> Q.Number:
  Q.mul(s, Q.sub(Q.one(), Q.pow(n, rho)))

def geom(+n: Nat, +rho: Q.Number) -> Q.Number:
  match n:
    case 0n:
      Q.zero()
    case 1n+p:
      Q.add(geom(p, rho), Q.pow(p, rho))

def cool(rho: Q.Number, w: Q.Number) -> Q.Number:
  Q.mul(rho, w)

def chebyshev_two(+x: Q.Number) -> Q.Number:
  Q.sub(Q.mul(Q.add(Q.one(), Q.one()), Q.mul(x, x)), Q.one())

def half() -> Q.Number:
  Q.Fraction{B.Pos{B.One{}}, B.Zero{}, B.Bit0{B.One{}}}

def pow2(n: Nat) -> B.Positive:
  match n:
    case 0n:
      B.One{}
    case 1n+p:
      B.Bit0{pow2(p)}

def half_gap(n: Nat) -> Q.Positive:
  Q.Positive{B.One{}, pow2(n)}
