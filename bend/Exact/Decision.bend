import Base
import ./Natural.bend as N
import ./Binary.bend as B
import ./BinaryProof.bend as BP
import ./Rational.bend as Q

# Equality by verified binary reflection avoids expanding large unary
# numerals in the checker. The final binary equality still needs evidence.
def cross_left(a: Q.Number, b: Q.Number) -> B.Whole:
  match a b:
    case Q.Fraction{ap, an, ad} Q.Fraction{bp, bn, bd}:
      B.add(B.mul(ap, B.Pos{bd}), B.mul(bn, B.Pos{ad}))

law cross_value:
  for +ap: B.Whole
  for +bn: B.Whole
  for +ad: B.Positive
  for +bd: B.Positive
  {B.value(B.add(B.mul(ap, B.Pos{bd}), B.mul(bn, B.Pos{ad}))) == N.add(N.mul(B.value(ap), B.positive_value(bd)), N.mul(B.value(bn), B.positive_value(ad))) : N.Number}
def cross_value(ap, bn, ad, bd):
  +x = B.mul(ap, B.Pos{bd})
  +y = B.mul(bn, B.Pos{ad})
  +vx = N.mul(B.value(ap), B.positive_value(bd))
  +vy = N.mul(B.value(bn), B.positive_value(ad))
  Equal.trans(N.Number, B.value(B.add(x, y)), N.add(B.value(x), B.value(y)), N.add(vx, vy), BP.add_correct(x, y),
    Equal.trans(N.Number, N.add(B.value(x), B.value(y)), N.add(vx, B.value(y)), N.add(vx, vy),
      Equal.cong(N.Number, N.Number, z => N.add(z, B.value(y)), B.value(x), vx, BP.mul_correct(ap, B.Pos{bd})),
      Equal.cong(N.Number, N.Number, z => N.add(vx, z), B.value(y), vy, BP.mul_correct(bn, B.Pos{ad}))))

law eq:
  for +a: Q.Number
  for +b: Q.Number
  for e: {cross_left(a, b) == cross_left(b, a) : B.Whole}
  Q.Eq(a, b)
def eq(a, b, e):
  match a b:
    case Q.Fraction{ap, an, ad} Q.Fraction{bp, bn, bd}:
      Q.Witness{(
        +l = B.add(B.mul(ap, B.Pos{bd}), B.mul(bn, B.Pos{ad}))
        +r = B.add(B.mul(bp, B.Pos{ad}), B.mul(an, B.Pos{bd}))
        +nl = N.add(N.mul(B.value(ap), B.positive_value(bd)), N.mul(B.value(bn), B.positive_value(ad)))
        +nr = N.add(N.mul(B.value(bp), B.positive_value(ad)), N.mul(B.value(an), B.positive_value(bd)))
        Equal.trans(N.Number, nl, B.value(l), nr,
          Equal.sym(N.Number, B.value(l), nl, cross_value(ap, bn, ad, bd)),
          Equal.trans(N.Number, B.value(l), B.value(r), nr,
            Equal.cong(B.Whole, N.Number, x => B.value(x), l, r, e), cross_value(bp, an, bd, ad)))
      )}
