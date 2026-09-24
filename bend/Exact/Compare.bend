import Base
import ./Natural.bend as N
import ./Binary.bend as B
import ./Rational.bend as Q
import ./RationalProof.bend as R
import ./RationalEquality.bend as E
import ./Reasoning.bend as C
import ./Cancellation.bend as Z
import ./Magnitude.bend as M
import ./MomentAlgebra.bend as A

# A certified comparison: either a <= b or b < a, each with its slack.
# It reads the sign of b - a from the verified magnitude decomposition,
# so it is exact but inherits that routine's unary runtime cost. The
# certificate is a thunk: running code reads only the tag, and a proof
# forces the equality chain, which is costly to evaluate at runtime.
type Decision<-a: Q.Number, -b: Q.Number> is Type:
  AtMost{proof: Unit -> Q.Le<a, b>}
  Exceeds{proof: Unit -> Q.Lt<b, a>}

law settle:
  for +a: Q.Number
  for +b: Q.Number
  for +m: Q.Nonnegative
  for e: Q.Eq(Q.sub(b, a), Q.of_nonnegative(m))
  Q.Eq(Q.add(a, Q.of_nonnegative(m)), b)
def settle(a, b, m, e):
  +qm = Q.of_nonnegative(m)
  E.trans(Q.add(a, qm), Q.add(a, Q.sub(b, a)), b,
    C.add_right(qm, Q.sub(b, a), a, E.sym(Q.sub(b, a), qm, e)), A.add_sub_cancel(a, b))

law overshoot:
  for +a: Q.Number
  for +b: Q.Number
  for +x: Q.Number
  for e: Q.Eq(Q.sub(b, a), Q.neg(x))
  Q.Eq(Q.add(b, x), a)
def overshoot(a, b, x, e):
  +back = Q.neg(Q.sub(b, a))
  E.trans(Q.add(b, x), Q.add(b, back), a,
    C.add_right(x, back, b,
      E.trans(x, Q.neg(Q.neg(x)), back, E.sym(Q.neg(Q.neg(x)), x, R.neg_neg(x)),
        C.neg_congr(Q.neg(x), Q.sub(b, a), E.sym(Q.sub(b, a), Q.neg(x), e)))),
    R.add_neg_sub(a, b))

# decompose reports equal operands as a zero positive magnitude; a zero
# negative magnitude still means a == b.
def decide_from(+a: Q.Number, +b: Q.Number, r: M.SignedMagnitude<Q.sub(b, a)>) -> Decision<a, b>:
  match r:
    case M.PositiveCase{+m, e}:
      AtMost{u => Q.Bound{m, settle(a, b, m, e(Unit{}))}}
    case M.NegativeCase{Q.Nonnegative{B.Zero{}, +d}, e}:
      AtMost{u => Q.Bound{Q.Nonnegative{B.Zero{}, d}, settle(a, b, Q.Nonnegative{B.Zero{}, d}, e(Unit{}))}}
    case M.NegativeCase{Q.Nonnegative{B.Pos{+k}, +d}, e}:
      Exceeds{u => Q.StrictBound{Q.Positive{k, d}, overshoot(a, b, Q.Fraction{B.Pos{k}, B.Zero{}, d}, e(Unit{}))}}

def decide(+a: Q.Number, +b: Q.Number) -> Decision<a, b>:
  decide_from(a, b, M.decompose(Q.sub(b, a)))

law lt_le:
  for +a: Q.Number
  for +b: Q.Number
  for h: Q.Lt<a, b>
  Q.Le<a, b>
def lt_le(a, b, h):
  match h:
    case Q.StrictBound{Q.Positive{n, d}, e}:
      Q.Bound{Q.Nonnegative{B.Pos{n}, d}, e}

# A positive numerator over a positive denominator is not zero.
law positive_nonzero:
  for +q: B.Positive
  for +d: B.Positive
  for e: Q.Eq(Q.Fraction{B.Pos{q}, B.Zero{}, d}, Q.zero())
  Empty
def positive_nonzero(q, d, e):
  match e:
    case Q.Witness{f}:
      +t = Z.positive_tail(q)
      +one = {N.S{N.Z{}} : N.Number}
      Z.zero_ne_succ(N.mul(t, one),
        Equal.trans(N.Number, N.Z{}, N.mul(B.positive_value(q), one), N.mul(N.S{t}, one),
          Equal.trans(N.Number, N.Z{}, N.add(N.mul(B.positive_value(q), one), N.Z{}), N.mul(B.positive_value(q), one),
            Equal.sym(N.Number, N.add(N.mul(B.positive_value(q), one), N.Z{}), N.Z{}, f),
            N.add_zero(N.mul(B.positive_value(q), one))),
          Equal.cong(N.Number, N.Number, x => N.mul(x, one), B.positive_value(q), N.S{t}, Z.positive(q))))

law slack_nonzero:
  for +s: Q.Nonnegative
  for +t: Q.Positive
  for e: Q.Eq(Q.add(Q.of_nonnegative(s), Q.of_positive(t)), Q.zero())
  Empty
def slack_nonzero(s, t, e):
  match s t:
    case Q.Nonnegative{B.Zero{}, sd} Q.Positive{tn, +td}:
      positive_nonzero(B.positive_mul(tn, sd), B.positive_mul(sd, td), e)
    case Q.Nonnegative{B.Pos{sn}, +sd} Q.Positive{tn, +td}:
      positive_nonzero(B.positive_add(B.positive_mul(sn, td), B.positive_mul(tn, sd)), B.positive_mul(sd, td), e)

# The two outcomes of a decision exclude each other.
law le_lt_absurd:
  for +a: Q.Number
  for +b: Q.Number
  for h: Q.Le<a, b>
  for g: Q.Lt<b, a>
  Empty
def le_lt_absurd(a, b, h, g):
  match h g:
    case Q.Bound{+s, e} Q.StrictBound{+t, f}:
      +qs = Q.of_nonnegative(s)
      +qt = Q.of_positive(t)
      +na = Q.neg(a)
      slack_nonzero(s, t,
        E.trans(Q.add(qs, qt), Q.add(na, Q.add(Q.add(a, qs), qt)), Q.zero(),
          E.sym(Q.add(na, Q.add(Q.add(a, qs), qt)), Q.add(qs, qt), R.cancel_front(a, qs, qt)),
          E.trans(Q.add(na, Q.add(Q.add(a, qs), qt)), Q.add(na, Q.add(b, qt)), Q.zero(),
            C.add_right(Q.add(Q.add(a, qs), qt), Q.add(b, qt), na, E.add_congr(Q.add(a, qs), b, qt, e)),
            E.trans(Q.add(na, Q.add(b, qt)), Q.add(na, a), Q.zero(),
              C.add_right(Q.add(b, qt), a, na, f), R.neg_add_self(a)))))

def pick(+a: Q.Number, +b: Q.Number, d: Decision<a, b>) -> Q.Number:
  match d:
    case AtMost{h}:
      b
    case Exceeds{g}:
      a

def max(+a: Q.Number, +b: Q.Number) -> Q.Number:
  pick(a, b, decide(a, b))

law pick_left:
  for +a: Q.Number
  for +b: Q.Number
  for d: Decision<a, b>
  Q.Le<a, pick(a, b, d)>
def pick_left(a, b, d):
  match d:
    case AtMost{h}:
      h(Unit{})
    case Exceeds{g}:
      Q.Bound{Q.Nonnegative{B.Zero{}, B.One{}}, R.add_zero(a)}

law pick_right:
  for +a: Q.Number
  for +b: Q.Number
  for d: Decision<a, b>
  Q.Le<b, pick(a, b, d)>
def pick_right(a, b, d):
  match d:
    case AtMost{h}:
      Q.Bound{Q.Nonnegative{B.Zero{}, B.One{}}, R.add_zero(b)}
    case Exceeds{g}:
      lt_le(b, a, g(Unit{}))

law pick_choice:
  for +a: Q.Number
  for +b: Q.Number
  for d: Decision<a, b>
  Or({pick(a, b, d) == a : Q.Number}, {pick(a, b, d) == b : Q.Number})
def pick_choice(a, b, d):
  match d:
    case AtMost{h}:
      Inr{{==}}
    case Exceeds{g}:
      Inl{{==}}

law max_left:
  for +a: Q.Number
  for +b: Q.Number
  Q.Le<a, max(a, b)>
def max_left(a, b):
  pick_left(a, b, decide(a, b))

law max_right:
  for +a: Q.Number
  for +b: Q.Number
  Q.Le<b, max(a, b)>
def max_right(a, b):
  pick_right(a, b, decide(a, b))

law max_choice:
  for +a: Q.Number
  for +b: Q.Number
  Or({max(a, b) == a : Q.Number}, {max(a, b) == b : Q.Number})
def max_choice(a, b):
  pick_choice(a, b, decide(a, b))
