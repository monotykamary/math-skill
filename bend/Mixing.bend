import Base
import ./Exact/Binary.bend as B
import ./Exact/Rational.bend as Q
import ./Exact/Magnitude.bend as A
import ./Finite.bend as F

type Observations is Data:
  NoObservations{}
  Observation{p: Q.Number, u: Q.Positive, tail: Observations}

def weight(u: Q.Positive) -> Q.Nonnegative:
  match u:
    case Q.Positive{n, d}:
      Q.Nonnegative{B.Pos{n}, d}

# This exact reference specification uses the proof-model comparison.
# It favors a small verified foundation over a fast absolute-value routine.
def deviation(p: Q.Number, u: Q.Positive) -> Q.Number:
  Q.of_nonnegative(A.magnitude(Q.sub(p, Q.of_positive(u))))

def rows(xs: Observations) -> F.Rows:
  match xs:
    case NoObservations{}:
      F.NoRows{}
    case Observation{p, +u, tail}:
      F.Row{weight(u), Q.div_positive(deviation(p, u), u), rows(tail)}

def total_deviation(xs: Observations) -> Q.Number:
  match xs:
    case NoObservations{}:
      Q.zero()
    case Observation{p, u, tail}:
      Q.add(deviation(p, u), total_deviation(tail))

def chi_square(xs: Observations) -> Q.Number:
  match xs:
    case NoObservations{}:
      Q.zero()
    case Observation{p, +u, tail}:
      +d = deviation(p, u)
      Q.add(Q.div_positive(Q.mul(d, d), u), chi_square(tail))

def mass(xs: Observations) -> Q.Number:
  F.weights(rows(xs))
