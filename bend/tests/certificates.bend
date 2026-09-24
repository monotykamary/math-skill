import Base
import ../Exact/Rational.bend as Q
import ../Exact/Decision.bend as D
import ../Exact/Order.bend as O
import ../Finite.bend as F
import ../FiniteProof.bend as P
import ../Mixing.bend as X
import ../MixingProof.bend as XP

def half_weight() -> Q.Nonnegative:
  Q.nonnegative_ratio(1n, 2n, Unit{})

def half_reference() -> Q.Positive:
  Q.positive_ratio(1n, 2n, Unit{}, Unit{})

def two() -> Q.Nonnegative:
  Q.nonnegative_ratio(2n, 1n, Unit{})

def one_slack() -> Q.Nonnegative:
  Q.nonnegative_ratio(1n, 1n, Unit{})

def samples() -> F.Samples:
  F.Sample{half_weight(), O.zero(), False{}, F.Sample{half_weight(), two(), True{}, F.NoSamples{}}}

def markov_example() -> Q.Le<Q.mul(Q.one(), F.selected_weight(samples())), F.expectation(samples())>:
  P.markov_finset(samples(), Q.one(),
    (Q.Bound{one_slack(), D.eq(Q.add(Q.one(), Q.one()), Q.of_nonnegative(two()), {==})}, Unit{}))

def rows() -> F.Rows:
  F.Row{half_weight(), Q.zero(), F.Row{half_weight(), Q.one(), F.NoRows{}}}

def convex_example() -> Q.Le<F.weighted_sum(rows()), Q.one()>:
  P.convex_avg_le_max(rows(), Q.one(),
    (O.nonnegative(one_slack()), (O.refl(Q.one()), Unit{})),
    D.eq(F.weights(rows()), Q.one(), {==}))

def observations() -> X.Observations:
  X.Observation{Q.ratio(3n, 4n, Unit{}), half_reference(),
    X.Observation{Q.ratio(1n, 4n, Unit{}), half_reference(), X.NoObservations{}}}

def mixing_example() -> Q.Le<Q.mul(X.total_deviation(observations()), X.total_deviation(observations())), Q.mul(X.mass(observations()), X.chi_square(observations()))>:
  XP.chi_tv_transfer_rat(observations())
