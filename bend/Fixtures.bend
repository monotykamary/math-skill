import Base
import ./Exact/Binary.bend as B
import ./Exact/Rational.bend as Q

# Literal denominators are positive binary values, not unchecked division.
def three_halves() -> Q.Number:
  Q.Fraction{B.from_nat(3n), B.Zero{}, B.Bit0{B.One{}}}

def nine_eighths() -> Q.Number:
  Q.Fraction{B.from_nat(9n), B.Zero{}, B.Bit0{B.Bit0{B.Bit0{B.One{}}}}}

def nine_tenths() -> Q.Number:
  Q.Fraction{B.from_nat(9n), B.Zero{}, B.Bit0{B.Bit1{B.Bit0{B.One{}}}}}

def fifteen_sixteenths() -> Q.Number:
  Q.Fraction{B.from_nat(15n), B.Zero{}, B.Bit0{B.Bit0{B.Bit0{B.Bit0{B.One{}}}}}}

# 9/10 - 3/4 = 3/20, strictly positive.
def crossing_gap_before() -> Q.Positive:
  Q.Positive{B.Bit1{B.One{}}, B.Bit0{B.Bit0{B.Bit1{B.Bit0{B.One{}}}}}}

# 9/8 - 9/10 = 9/40, nonnegative.
def crossing_gap_after() -> Q.Nonnegative:
  Q.Nonnegative{B.from_nat(9n), B.Bit0{B.Bit0{B.Bit0{B.Bit1{B.Bit0{B.One{}}}}}}}
