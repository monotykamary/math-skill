import Base
import ../Exact/Binary.bend as B
import ../Exact/Rational.bend as Q
import ../Exact/Compare.bend as K
import ../Exact/Inverse.bend as I
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

def draws() -> F.Draws:
  F.Draw{half_weight(), O.zero(), F.Draw{half_weight(), two(), F.NoDraws{}}}

def markov_threshold_example() -> Q.Le<Q.mul(Q.one(), F.selected_weight(F.threshold(Q.one(), draws()))), F.mean(draws())>:
  P.markov_threshold(draws(), Q.one())

# At threshold 1 only the draw at 2 is kept, so the selected weight is 1/2.
def threshold_example() -> Q.Eq(F.selected_weight(F.threshold(Q.one(), draws())), Q.ratio(1n, 2n, Unit{})):
  D.eq(F.selected_weight(F.threshold(Q.one(), draws())), Q.ratio(1n, 2n, Unit{}), {==})

def signed_rows() -> F.Rows:
  F.Row{half_weight(), Q.neg(Q.ratio(3n, 2n, Unit{})), F.Row{half_weight(), Q.ratio(1n, 4n, Unit{}), F.NoRows{}}}

# max(1/2, -3/2, 1/4) is the seed 1/2; max(0, 1) is 1.
def maximum_seed_example() -> {F.maximum(signed_rows(), Q.ratio(1n, 2n, Unit{})) == Q.ratio(1n, 2n, Unit{}) : Q.Number}:
  {==}

def maximum_value_example() -> {F.maximum(F.Row{half_weight(), Q.one(), F.NoRows{}}, Q.zero()) == Q.one() : Q.Number}:
  {==}

def convex_maximum_example() -> Q.Le<F.weighted_sum(rows()), F.maximum(F.Row{half_weight(), Q.one(), F.NoRows{}}, Q.zero())>:
  P.convex_avg_le_maximum(half_weight(), Q.zero(), F.Row{half_weight(), Q.one(), F.NoRows{}},
    D.eq(F.weights(rows()), Q.one(), {==}))

def inverse_examples() -> Q.Eq(I.div(Q.one(), Q.two()), Q.ratio(1n, 2n, Unit{})) & Q.Eq(I.inv(Q.neg(Q.ratio(3n, 4n, Unit{}))), Q.neg(Q.ratio(4n, 3n, Unit{}))) & Q.Eq(I.inv(Q.zero()), Q.zero()):
  (D.eq(I.div(Q.one(), Q.two()), Q.ratio(1n, 2n, Unit{}), {==}),
   D.eq(I.inv(Q.neg(Q.ratio(3n, 4n, Unit{}))), Q.neg(Q.ratio(4n, 3n, Unit{})), {==}),
   D.eq(I.inv(Q.zero()), Q.zero(), {==}))

def cancel_example() -> Q.Eq(Q.mul(Q.two(), I.inv(Q.two())), Q.one()):
  I.mul_inv_cancel(Q.two(), e => K.positive_nonzero(B.Bit0{B.One{}}, B.One{}, e))

# Roots 1/2 of 1/4 and 2/3 of 4/9, checked by computation.
def rooted() -> X.Rooted:
  X.RootedObservation{Q.ratio(3n, 4n, Unit{}), Q.positive_ratio(1n, 4n, Unit{}, Unit{}), Q.positive_ratio(1n, 2n, Unit{}, Unit{}),
    X.RootedObservation{Q.neg(Q.ratio(1n, 3n, Unit{})), Q.positive_ratio(4n, 9n, Unit{}, Unit{}), Q.positive_ratio(2n, 3n, Unit{}, Unit{}), X.NoRooted{}}}

def rooted_example() -> Q.Le<Q.mul(X.total_deviation(X.unrooted(rooted())), X.total_deviation(X.unrooted(rooted()))), Q.mul(X.mass(X.unrooted(rooted())), X.root_chi_square(rooted()))>:
  XP.chi_tv_transfer_sqrt(rooted(),
    (D.eq(Q.mul(Q.ratio(1n, 2n, Unit{}), Q.ratio(1n, 2n, Unit{})), Q.ratio(1n, 4n, Unit{}), {==}),
     (D.eq(Q.mul(Q.ratio(2n, 3n, Unit{}), Q.ratio(2n, 3n, Unit{})), Q.ratio(4n, 9n, Unit{}), {==}), Unit{})))

# The root chi-square matches its closed value: (1/2 / 1/2)^2 + (7/9 / 2/3)^2 = 1 + 49/36.
def root_chi_value() -> Q.Eq(X.root_chi_square(rooted()), Q.ratio(85n, 36n, Unit{})):
  D.eq(X.root_chi_square(rooted()), Q.ratio(85n, 36n, Unit{}), {==})
