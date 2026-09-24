import Base
import ./Natural.bend as N
import ./Binary.bend as B

# (positive - negative) / denominator. Positive denominators are enforced
# by their datatype. Fractions are intentionally not reduced; equality is
# cross multiplication, never structural equality of representations.
type Number is Data:
  Fraction{positive: B.Whole, negative: B.Whole, denominator: B.Positive}

type Nonnegative is Data:
  Nonnegative{numerator: B.Whole, denominator: B.Positive}

type Positive is Data:
  Positive{numerator: B.Positive, denominator: B.Positive}

def zero() -> Number:
  Fraction{B.Zero{}, B.Zero{}, B.One{}}

def one() -> Number:
  Fraction{B.Pos{B.One{}}, B.Zero{}, B.One{}}

# Literal fractions n/d. Pass Unit{} for each nonzero certificate; a zero
# denominator (or a zero Positive numerator) does not check.
def ratio(n: Nat, d: Nat, nd: B.NonZero(d)) -> Number:
  Fraction{B.from_nat(n), B.Zero{}, B.positive_from_nat(d, nd)}

def nonnegative_ratio(n: Nat, d: Nat, nd: B.NonZero(d)) -> Nonnegative:
  Nonnegative{B.from_nat(n), B.positive_from_nat(d, nd)}

def positive_ratio(n: Nat, d: Nat, nn: B.NonZero(n), nd: B.NonZero(d)) -> Positive:
  Positive{B.positive_from_nat(n, nn), B.positive_from_nat(d, nd)}

def two() -> Number:
  ratio(2n, 1n, Unit{})

def of_nonnegative(a: Nonnegative) -> Number:
  match a:
    case Nonnegative{n, d}:
      Fraction{n, B.Zero{}, d}

def of_positive(a: Positive) -> Number:
  match a:
    case Positive{n, d}:
      Fraction{B.Pos{n}, B.Zero{}, d}

def neg(a: Number) -> Number:
  match a:
    case Fraction{p, n, d}:
      Fraction{n, p, d}

def add(a: Number, b: Number) -> Number:
  match a b:
    case Fraction{ap, an, +ad} Fraction{bp, bn, +bd}:
      Fraction{B.add(B.mul(ap, B.Pos{bd}), B.mul(bp, B.Pos{ad})),
        B.add(B.mul(an, B.Pos{bd}), B.mul(bn, B.Pos{ad})), B.positive_mul(ad, bd)}

def sub(a: Number, b: Number) -> Number:
  add(a, neg(b))

def mul(a: Number, b: Number) -> Number:
  match a b:
    case Fraction{+ap, +an, ad} Fraction{+bp, +bn, bd}:
      Fraction{B.add(B.mul(ap, bp), B.mul(an, bn)),
        B.add(B.mul(ap, bn), B.mul(an, bp)), B.positive_mul(ad, bd)}

def pow(n: Nat, +a: Number) -> Number:
  match n:
    case 0n:
      one()
    case 1n+p:
      mul(a, pow(p, a))

# Total, exact division by a value known to be strictly positive.
# There is deliberately no unchecked division by an arbitrary Number.
def div_positive(a: Number, b: Positive) -> Number:
  match a b:
    case Fraction{ap, an, ad} Positive{bn, +bd}:
      Fraction{B.mul(ap, B.Pos{bd}), B.mul(an, B.Pos{bd}), B.positive_mul(ad, bn)}

def nonnegative_add(a: Nonnegative, b: Nonnegative) -> Nonnegative:
  match a b:
    case Nonnegative{an, +ad} Nonnegative{bn, +bd}:
      Nonnegative{B.add(B.mul(an, B.Pos{bd}), B.mul(bn, B.Pos{ad})), B.positive_mul(ad, bd)}

def nonnegative_mul(a: Nonnegative, b: Nonnegative) -> Nonnegative:
  match a b:
    case Nonnegative{an, ad} Nonnegative{bn, bd}:
      Nonnegative{B.mul(an, bn), B.positive_mul(ad, bd)}

def CrossEq(a: Number, b: Number) -> Data:
  match a b:
    case Fraction{ap, an, ad} Fraction{bp, bn, bd}:
      {N.add(N.mul(B.value(ap), B.positive_value(bd)), N.mul(B.value(bn), B.positive_value(ad))) ==
       N.add(N.mul(B.value(bp), B.positive_value(ad)), N.mul(B.value(an), B.positive_value(bd))) : N.Number}

# Keep the relation indexed by binary rationals. The wrapper prevents the
# checker from eagerly expanding large unary cross products merely to
# compare theorem types; its evidence is still the exact natural equality.
type Equality<-a: Number, -b: Number> is Data:
  Witness{evidence: CrossEq(a, b)}

def Eq(a: Number, b: Number) -> Data:
  Equality<a, b>

def Ne(a: Number, b: Number) -> Type:
  Eq(a, b) -> Empty

# A constructive order certificate: b = a + a nonnegative rational.
# The evidence uses exact cross multiplication, not a floating comparison.
type Le<-a: Number, -b: Number> is Type:
  Bound{slack: Nonnegative, evidence: Eq(add(a, of_nonnegative(slack)), b)}

type Lt<-a: Number, -b: Number> is Type:
  StrictBound{slack: Positive, evidence: Eq(add(a, of_positive(slack)), b)}
