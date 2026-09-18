import Base
import ./Natural.bend as N
import ./Binary.bend as B

def pred(a: N.Number) -> N.Number:
  match a:
    case N.Z{}:
      N.Z{}
    case N.S{p}:
      p

def discriminator(a: N.Number) -> Type:
  match a:
    case N.Z{}:
      Unit
    case N.S{p}:
      Empty

law zero_ne_succ:
  for a: N.Number
  for e: {N.Z{} == N.S{a} : N.Number}
  Empty
def zero_ne_succ(a, e):
  %e : discriminator(_)
  Unit{}

law add_cancel:
  for +a: N.Number
  for +b: N.Number
  for +c: N.Number
  for e: {N.add(a, b) == N.add(a, c) : N.Number}
  {b == c : N.Number}
def add_cancel(a, b, c, e):
  match a:
    case N.Z{}:
      e
    case N.S{p}:
      add_cancel(p, b, c, Equal.cong(N.Number, N.Number, x => pred(x), N.S{N.add(p, b)}, N.S{N.add(p, c)}, e))

law absurd:
  for -A: Type
  for e: Empty
  A
def absurd(A, e):
  match e:

law mul_cancel:
  for +b: N.Number
  for +c: N.Number
  for +p: N.Number
  for e: {N.mul(N.S{p}, b) == N.mul(N.S{p}, c) : N.Number}
  {b == c : N.Number}
def mul_cancel(b, c, p, e):
  match b c:
    case N.Z{} N.Z{}:
      {==}
    case N.Z{} N.S{q}:
      absurd({N.Z{} == N.S{q} : N.Number}, zero_ne_succ(N.add(q, N.mul(p, N.S{q})),
        Equal.trans(N.Number, N.Z{}, N.mul(N.S{p}, N.Z{}), N.mul(N.S{p}, N.S{q}),
          Equal.sym(N.Number, N.mul(N.S{p}, N.Z{}), N.Z{}, N.mul_zero(N.S{p})), e)))
    case N.S{q} N.Z{}:
      absurd({N.S{q} == N.Z{} : N.Number}, zero_ne_succ(N.add(q, N.mul(p, N.S{q})),
        Equal.trans(N.Number, N.Z{}, N.mul(N.S{p}, N.Z{}), N.mul(N.S{p}, N.S{q}),
          Equal.sym(N.Number, N.mul(N.S{p}, N.Z{}), N.Z{}, N.mul_zero(N.S{p})),
          Equal.sym(N.Number, N.mul(N.S{p}, N.S{q}), N.mul(N.S{p}, N.Z{}), e))))
    case N.S{q} N.S{r}:
      Equal.cong(N.Number, N.Number, x => N.S{x}, q, r, mul_cancel(q, r, p,
        add_cancel(N.S{p}, N.mul(N.S{p}, q), N.mul(N.S{p}, r),
          Equal.trans(N.Number, N.add(N.S{p}, N.mul(N.S{p}, q)), N.mul(N.S{p}, N.S{q}), N.add(N.S{p}, N.mul(N.S{p}, r)),
            Equal.sym(N.Number, N.mul(N.S{p}, N.S{q}), N.add(N.S{p}, N.mul(N.S{p}, q)), N.mul_succ(N.S{p}, q)),
            Equal.trans(N.Number, N.mul(N.S{p}, N.S{q}), N.mul(N.S{p}, N.S{r}), N.add(N.S{p}, N.mul(N.S{p}, r)), e, N.mul_succ(N.S{p}, r))))))

def positive_tail(a: B.Positive) -> N.Number:
  match a:
    case B.One{}:
      N.Z{}
    case B.Bit0{+p}:
      N.add(positive_tail(p), N.S{positive_tail(p)})
    case B.Bit1{+p}:
      N.S{N.add(positive_tail(p), N.S{positive_tail(p)})}

law positive:
  for +a: B.Positive
  {B.positive_value(a) == N.S{positive_tail(a)} : N.Number}
def positive(a):
  match a:
    case B.One{}:
      {==}
    case B.Bit0{p}:
      Equal.cong(N.Number, N.Number, +x => N.add(x, x), B.positive_value(p), N.S{positive_tail(p)}, positive(p))
    case B.Bit1{p}:
      Equal.cong(N.Number, N.Number, +x => N.S{N.add(x, x)}, B.positive_value(p), N.S{positive_tail(p)}, positive(p))
