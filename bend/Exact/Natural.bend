import Base

# An unbounded inductive model. Core executable arithmetic uses binary
# digits. The verified reference magnitude routine also traverses this
# unary model; see README.md for its numeric-size performance limit.
type Number is Data:
  Z{}
  S{pred: Number}

def add(a: Number, b: Number) -> Number:
  match a:
    case Z{}:
      b
    case S{p}:
      S{add(p, b)}

def mul(a: Number, +b: Number) -> Number:
  match a:
    case Z{}:
      Z{}
    case S{p}:
      add(b, mul(p, b))

law add_zero:
  for a: Number
  {add(a, Z{}) == a : Number}
def add_zero(a):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_zero(p) : {S{add(p, Z{})} == S{_} : Number}
      {==}

law add_succ:
  for a: Number
  for b: Number
  {add(a, S{b}) == S{add(a, b)} : Number}
def add_succ(a, b):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_succ(p, b) : {S{add(p, S{b})} == S{_} : Number}
      {==}

law add_comm:
  for +a: Number
  for +b: Number
  {add(a, b) == add(b, a) : Number}
def add_comm(a, b):
  match a:
    case Z{}:
      Equal.sym(Number, add(b, Z{}), b, add_zero(b))
    case S{p}:
      Equal.trans(Number, S{add(p, b)}, S{add(b, p)}, add(b, S{p}),
        Equal.cong(Number, Number, x => S{x}, add(p, b), add(b, p), add_comm(p, b)),
        Equal.sym(Number, add(b, S{p}), S{add(b, p)}, add_succ(b, p)))

law add_assoc:
  for a: Number
  for b: Number
  for c: Number
  {add(add(a, b), c) == add(a, add(b, c)) : Number}
def add_assoc(a, b, c):
  match a:
    case Z{}:
      {==}
    case S{p}:
      %add_assoc(p, b, c) : {S{add(add(p, b), c)} == S{_} : Number}
      {==}

law mul_zero:
  for a: Number
  {mul(a, Z{}) == Z{} : Number}
def mul_zero(a):
  match a:
    case Z{}:
      {==}
    case S{p}:
      mul_zero(p)

law add_swap:
  for +a: Number
  for +b: Number
  for +c: Number
  {add(a, add(b, c)) == add(b, add(a, c)) : Number}
def add_swap(a, b, c):
  Equal.trans(Number, add(a, add(b, c)), add(add(a, b), c), add(b, add(a, c)),
    Equal.sym(Number, add(add(a, b), c), add(a, add(b, c)), add_assoc(a, b, c)),
    Equal.trans(Number, add(add(a, b), c), add(add(b, a), c), add(b, add(a, c)),
      Equal.cong(Number, Number, x => add(x, c), add(a, b), add(b, a), add_comm(a, b)),
      add_assoc(b, a, c)))

law mul_succ:
  for +a: Number
  for +b: Number
  {mul(a, S{b}) == add(a, mul(a, b)) : Number}
def mul_succ(a, b):
  match a:
    case Z{}:
      {==}
    case S{p}:
      Equal.trans(Number, S{add(b, mul(p, S{b}))}, S{add(b, add(p, mul(p, b)))}, S{add(p, add(b, mul(p, b)))},
        Equal.cong(Number, Number, x => S{add(b, x)}, mul(p, S{b}), add(p, mul(p, b)), mul_succ(p, b)),
        Equal.cong(Number, Number, x => S{x}, add(b, add(p, mul(p, b))), add(p, add(b, mul(p, b))), add_swap(b, p, mul(p, b))))

law mul_comm:
  for +a: Number
  for +b: Number
  {mul(a, b) == mul(b, a) : Number}
def mul_comm(a, b):
  match a:
    case Z{}:
      Equal.sym(Number, mul(b, Z{}), Z{}, mul_zero(b))
    case S{p}:
      Equal.trans(Number, add(b, mul(p, b)), add(b, mul(b, p)), mul(b, S{p}),
        Equal.cong(Number, Number, x => add(b, x), mul(p, b), mul(b, p), mul_comm(p, b)),
        Equal.sym(Number, mul(b, S{p}), add(b, mul(b, p)), mul_succ(b, p)))

law mul_add:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(add(a, b), c) == add(mul(a, c), mul(b, c)) : Number}
def mul_add(a, b, c):
  match a:
    case Z{}:
      {==}
    case S{p}:
      Equal.trans(Number, add(c, mul(add(p, b), c)), add(c, add(mul(p, c), mul(b, c))), add(add(c, mul(p, c)), mul(b, c)),
        Equal.cong(Number, Number, x => add(c, x), mul(add(p, b), c), add(mul(p, c), mul(b, c)), mul_add(p, b, c)),
        Equal.sym(Number, add(add(c, mul(p, c)), mul(b, c)), add(c, add(mul(p, c), mul(b, c))), add_assoc(c, mul(p, c), mul(b, c))))

law add_mul:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(a, add(b, c)) == add(mul(a, b), mul(a, c)) : Number}
def add_mul(a, b, c):
  Equal.trans(Number, mul(a, add(b, c)), mul(add(b, c), a), add(mul(a, b), mul(a, c)),
    mul_comm(a, add(b, c)),
    Equal.trans(Number, mul(add(b, c), a), add(mul(b, a), mul(c, a)), add(mul(a, b), mul(a, c)),
      mul_add(b, c, a),
      Equal.trans(Number, add(mul(b, a), mul(c, a)), add(mul(a, b), mul(c, a)), add(mul(a, b), mul(a, c)),
        Equal.cong(Number, Number, x => add(x, mul(c, a)), mul(b, a), mul(a, b), mul_comm(b, a)),
        Equal.cong(Number, Number, x => add(mul(a, b), x), mul(c, a), mul(a, c), mul_comm(c, a)))))

law mul_one:
  for +a: Number
  {mul(a, S{Z{}}) == a : Number}
def mul_one(a):
  Equal.trans(Number, mul(a, S{Z{}}), add(a, mul(a, Z{})), a,
    mul_succ(a, Z{}),
    Equal.trans(Number, add(a, mul(a, Z{})), add(a, Z{}), a,
      Equal.cong(Number, Number, x => add(a, x), mul(a, Z{}), Z{}, mul_zero(a)),
      add_zero(a)))

law mul_assoc:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(mul(a, b), c) == mul(a, mul(b, c)) : Number}
def mul_assoc(a, b, c):
  match a:
    case Z{}:
      {==}
    case S{p}:
      Equal.trans(Number, mul(add(b, mul(p, b)), c), add(mul(b, c), mul(mul(p, b), c)), add(mul(b, c), mul(p, mul(b, c))),
        mul_add(b, mul(p, b), c),
        Equal.cong(Number, Number, x => add(mul(b, c), x), mul(mul(p, b), c), mul(p, mul(b, c)), mul_assoc(p, b, c)))

law mul_swap:
  for +a: Number
  for +b: Number
  for +c: Number
  {mul(a, mul(b, c)) == mul(b, mul(a, c)) : Number}
def mul_swap(a, b, c):
  Equal.trans(Number, mul(a, mul(b, c)), mul(mul(a, b), c), mul(b, mul(a, c)),
    Equal.sym(Number, mul(mul(a, b), c), mul(a, mul(b, c)), mul_assoc(a, b, c)),
    Equal.trans(Number, mul(mul(a, b), c), mul(mul(b, a), c), mul(b, mul(a, c)),
      Equal.cong(Number, Number, x => mul(x, c), mul(a, b), mul(b, a), mul_comm(a, b)),
      mul_assoc(b, a, c)))
