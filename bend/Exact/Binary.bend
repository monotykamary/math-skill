import Base
import ./Natural.bend as N

# Canonical, least-significant-bit-first binary positive integers.
# There is no fixed word-size limit and no leading-zero representation.
type Positive is Data:
  One{}
  Bit0{tail: Positive}
  Bit1{tail: Positive}

type Whole is Data:
  Zero{}
  Pos{bits: Positive}

def inc(a: Positive) -> Positive:
  match a:
    case One{}:
      Bit0{One{}}
    case Bit0{p}:
      Bit1{p}
    case Bit1{p}:
      Bit0{inc(p)}

def positive_add(a: Positive, b: Positive) -> Positive:
  match a b:
    case One{} b:
      inc(b)
    case Bit0{p} One{}:
      Bit1{p}
    case Bit1{p} One{}:
      Bit0{inc(p)}
    case Bit0{p} Bit0{q}:
      Bit0{positive_add(p, q)}
    case Bit0{p} Bit1{q}:
      Bit1{positive_add(p, q)}
    case Bit1{p} Bit0{q}:
      Bit1{positive_add(p, q)}
    case Bit1{p} Bit1{q}:
      Bit0{inc(positive_add(p, q))}

def positive_mul(a: Positive, +b: Positive) -> Positive:
  match a:
    case One{}:
      b
    case Bit0{p}:
      Bit0{positive_mul(p, b)}
    case Bit1{p}:
      positive_add(b, Bit0{positive_mul(p, b)})

def add(a: Whole, b: Whole) -> Whole:
  match a b:
    case Zero{} b:
      b
    case Pos{p} Zero{}:
      Pos{p}
    case Pos{p} Pos{q}:
      Pos{positive_add(p, q)}

def mul(a: Whole, b: Whole) -> Whole:
  match a b:
    case Zero{} b:
      Zero{}
    case Pos{p} Zero{}:
      Zero{}
    case Pos{p} Pos{q}:
      Pos{positive_mul(p, q)}

def positive_value(a: Positive) -> N.Number:
  match a:
    case One{}:
      N.S{N.Z{}}
    case Bit0{+p}:
      N.add(positive_value(p), positive_value(p))
    case Bit1{+p}:
      N.S{N.add(positive_value(p), positive_value(p))}

def value(a: Whole) -> N.Number:
  match a:
    case Zero{}:
      N.Z{}
    case Pos{p}:
      positive_value(p)

def successor(a: Whole) -> Whole:
  match a:
    case Zero{}:
      Pos{One{}}
    case Pos{p}:
      Pos{inc(p)}

# This bounded constructor is only a convenience for small literals.
# The arithmetic itself has no Nat-sized limit.
def from_nat(n: Nat) -> Whole:
  match n:
    case 0n:
      Zero{}
    case 1n+p:
      successor(from_nat(p))

# A literal's nonzero certificate: Unit{} checks by computation for any
# nonzero Nat literal; 0n asks for an Empty, which cannot be written.
def NonZero(n: Nat) -> Type:
  match n:
    case 0n:
      Empty
    case 1n+p:
      Unit

def successor_positive(n: Nat) -> Positive:
  match n:
    case 0n:
      One{}
    case 1n+p:
      inc(successor_positive(p))

def positive_from_nat(n: Nat, nz: NonZero(n)) -> Positive:
  match n:
    case 0n:
      match nz:
    case 1n+p:
      successor_positive(p)

def positive_show(a: Positive) -> String:
  match a:
    case One{}:
      "1"
    case Bit0{p}:
      positive_show(p) ++ "0"
    case Bit1{p}:
      positive_show(p) ++ "1"

def show(a: Whole) -> String:
  match a:
    case Zero{}:
      "0"
    case Pos{p}:
      positive_show(p)
