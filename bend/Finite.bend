import Base
import ./Exact/Rational.bend as Q

# Lists make the finite carrier explicit. Repeated rows are allowed;
# all the inequalities therefore also apply to finite sets.
type Rows is Data:
  NoRows{}
  Row{weight: Q.Nonnegative, value: Q.Number, tail: Rows}

def weights(xs: Rows) -> Q.Number:
  match xs:
    case NoRows{}:
      Q.zero()
    case Row{w, v, tail}:
      Q.add(Q.of_nonnegative(w), weights(tail))

def weighted_sum(xs: Rows) -> Q.Number:
  match xs:
    case NoRows{}:
      Q.zero()
    case Row{w, v, tail}:
      Q.add(Q.mul(Q.of_nonnegative(w), v), weighted_sum(tail))

def AllBelow(+bound: Q.Number, xs: Rows) -> Type:
  match xs:
    case NoRows{}:
      Unit
    case Row{w, v, tail}:
      Q.Le<v, bound> & AllBelow(bound, tail)

# A chosen subset with explicit threshold certificates. The Markov bound
# holds for ANY subset whose selected observations reach the threshold;
# selecting precisely all observations above it is the usual corollary.
type Samples is Data:
  NoSamples{}
  Sample{weight: Q.Nonnegative, value: Q.Nonnegative, chosen: Bool, tail: Samples}

def selected_weight(xs: Samples) -> Q.Number:
  match xs:
    case NoSamples{}:
      Q.zero()
    case Sample{w, x, chosen, tail}:
      match chosen:
        case False{}:
          selected_weight(tail)
        case True{}:
          Q.add(Q.of_nonnegative(w), selected_weight(tail))

def expectation(xs: Samples) -> Q.Number:
  match xs:
    case NoSamples{}:
      Q.zero()
    case Sample{w, x, chosen, tail}:
      Q.add(Q.mul(Q.of_nonnegative(w), Q.of_nonnegative(x)), expectation(tail))

def Above(+threshold: Q.Number, xs: Samples) -> Type:
  match xs:
    case NoSamples{}:
      Unit
    case Sample{w, x, chosen, tail}:
      match chosen:
        case False{}:
          Above(threshold, tail)
        case True{}:
          Q.Le<threshold, Q.of_nonnegative(x)> & Above(threshold, tail)
