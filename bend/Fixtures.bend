import Base
import ./Exact/Rational.bend as Q

# Literal denominators carry nonzero certificates, not unchecked division.
def three_halves() -> Q.Number:
  Q.ratio(3n, 2n, Unit{})

def nine_eighths() -> Q.Number:
  Q.ratio(9n, 8n, Unit{})

def nine_tenths() -> Q.Number:
  Q.ratio(9n, 10n, Unit{})

def fifteen_sixteenths() -> Q.Number:
  Q.ratio(15n, 16n, Unit{})

# 9/10 - 3/4 = 3/20, strictly positive.
def crossing_gap_before() -> Q.Positive:
  Q.positive_ratio(3n, 20n, Unit{}, Unit{})

# 9/8 - 9/10 = 9/40, nonnegative.
def crossing_gap_after() -> Q.Nonnegative:
  Q.nonnegative_ratio(9n, 40n, Unit{})
