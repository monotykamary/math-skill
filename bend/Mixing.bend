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

# Observations that also carry a square root s of each reference weight u.
# Roots certifies s * s = u; the root then replaces Lean's Real.sqrt u.
type Rooted is Data:
  NoRooted{}
  RootedObservation{p: Q.Number, u: Q.Positive, root: Q.Positive, tail: Rooted}

def Roots(xs: Rooted) -> Type:
  match xs:
    case NoRooted{}:
      Unit
    case RootedObservation{p, +u, +s, tail}:
      Q.Eq(Q.mul(Q.of_positive(s), Q.of_positive(s)), Q.of_positive(u)) & Roots(tail)

def unrooted(xs: Rooted) -> Observations:
  match xs:
    case NoRooted{}:
      NoObservations{}
    case RootedObservation{p, u, s, tail}:
      Observation{p, u, unrooted(tail)}

# sum of (|p - u| / s)^2, Lean's sum of (|p - u| / sqrt u)^2.
def root_chi_square(xs: Rooted) -> Q.Number:
  match xs:
    case NoRooted{}:
      Q.zero()
    case RootedObservation{p, u, +s, tail}:
      +r = Q.div_positive(deviation(p, u), s)
      Q.add(Q.mul(r, r), root_chi_square(tail))

# Cauchy-Schwarz rows weighted by s * s rather than u.
def squared_rows(xs: Rooted) -> F.Rows:
  match xs:
    case NoRooted{}:
      F.NoRows{}
    case RootedObservation{p, u, +s, tail}:
      +w = Q.positive_mul(s, s)
      F.Row{weight(w), Q.div_positive(deviation(p, u), w), squared_rows(tail)}
